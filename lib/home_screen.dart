import 'dart:collection';

import 'package:boodget/trans_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'app_header.dart';
import 'main.dart';
import 'new_trans_dialog.dart';

typedef UpdateAmountCallback = void Function(double amount);
typedef DeleteCallback = void Function(TransItem purchaseItem);

class HomeScreenState extends State<HomeScreen> {
  String currentPeriod = DateFormat('MMM-yyyy').format(DateTime.now());
  String? budgetId;

  final storageRef = FirebaseFirestore.instance;

  Future<QuerySnapshot<Budget>> loadCurrentBudget() async {
    return FirebaseFirestore.instance
        .collection('budget')
        .where('period', isEqualTo: currentPeriod)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Budget.fromJson(snapshot.data()!),
          toFirestore: (budget, options) => budget.toJson(),
        )
        .get(); // load your data from SharedPreferences
  }

  Future<DocumentReference<Budget>> createNewBudget() {
    Budget newBudget =
        Budget(period: currentPeriod, total: 1000, remaining: 1000);

    return storageRef
        .collection("budget")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Budget.fromJson(snapshot.data()!),
          toFirestore: (budget, options) => budget.toJson(),
        )
        .add(newBudget);
  }

  addTransToFireBase(Purchase newItem) async {
    storageRef
        .collection("budget")
        .doc(budgetId)
        .collection('purchases')
        .doc()
        .set(newItem.toJson())
        .then((value) => updateBudgetRemaining(newItem.amount as double))
        .onError((e, _) => print("Error writing document: $e"));
  }

  updateBudgetRemaining(double amount) async {
    final sfDocRef = storageRef.collection("budget").doc(budgetId);

    storageRef.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);
      // Note: this could be done without a transaction
      //       by updating the population using FieldValue.increment()
      final newAmount =
          double.parse(snapshot.get("remaining").toString()) - amount;
      transaction.update(sfDocRef, {"remaining": newAmount});
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  @override
  void initState() {
    super.initState();

    loadCurrentBudget().then(
      (currentBudget) {
        // Create a new budget if out-of-date
        if (currentBudget.docs.isEmpty ||
            currentBudget.docs[0].data().period != currentPeriod) {
          createNewBudget().then((value) => {
                setState(() {
                  budgetId = value.id;
                })
              });
        } else {
          setState(() {
            budgetId = currentBudget.docs[0].id;
          });
        }
      },
      onError: (e) => print("Error getting budget $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (budgetId == null) {
      loadCurrentBudget();
      return const LoadingScreen();
    } else {
      final budgetStream = FirebaseFirestore.instance
          .collection('budget')
          .doc(budgetId)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Budget.fromJson(snapshot.data()!),
            toFirestore: (budget, options) => budget.toJson(),
          )
          .snapshots();

      final purchases = FirebaseFirestore.instance
          .collection('budget')
          .doc(budgetId)
          .collection('purchases')
          .orderBy('created', descending: true)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Purchase.fromJson(snapshot.data()!),
            toFirestore: (purchase, options) => purchase.toJson(),
          )
          .snapshots();

      return Scaffold(
        drawer: const SideDrawer(),
        body: Center(
            child: MainScreen(
          budget: budgetStream,
          purchases: purchases,
          budgetId: budgetId as String,
          onUpdateAmount: (amount) => updateBudgetRemaining(amount),
        )),
        floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          elevation: 0,
          icon: const Icon(Icons.add),
          label: const Text('New Transaction'),
          backgroundColor: const Color(0xFFA6D3A0),
          foregroundColor: const Color(0xFFFFFFFF),
          tooltip: 'Add a new transaction',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const NewTransDialog(),
            ).then((value) => {if (value != null) addTransToFireBase(value)});
          },
        ).animate().flipV(),
      );
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  String budgetId;
  Stream<DocumentSnapshot<Budget>> budget;
  Stream<QuerySnapshot<Purchase>> purchases;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final UpdateAmountCallback onUpdateAmount;

  MainScreen(
      {super.key,
      required this.budget,
      required this.purchases,
      required this.budgetId,
      required this.onUpdateAmount});

  deletePurchase(TransItem purchaseItem) {
    FirebaseFirestore.instance
        .collection("budget")
        .doc(budgetId)
        .collection('purchases')
        .doc(purchaseItem.docId)
        .delete()
        .then(
          (doc) => onUpdateAmount(-(purchaseItem.purchase.amount as double)),
          onError: (e) => print("Error updating document $e"),
        );
  }

  // ignore: override_on_non_overriding_member
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder(
          stream: budget,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;

            return AppHeader(
              budget: data.data() as Budget,
            );
          },
        ),
        const SizedBox(
          height: 42,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Transactions',
                style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Purchase>>(
            // stream: purchaseRef.snapshots(),
            stream: purchases,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.requireData;

              List<Widget> tabInfoItems = [
                for (final doc in data.docs)
                  TransItem(
                    doc.data(),
                    doc.id,
                    onDeletePurchase: (id) => deletePurchase(id),
                  )
              ];

              // // Animate all of the info items in the list:
              // tabInfoItems = tabInfoItems
              //     .animate(interval: 250.ms, onComplete: (controller) => controller.stop(),)
              //     .fadeIn(duration: 300.ms, delay: 50.ms)
              //     .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
              //     .move(begin: const Offset(-48, 0), curve: Curves.easeOutQuad);

              // Animate all of the info items in the list:
              tabInfoItems =
                  tabInfoItems.animate(interval: 400.ms).fade(duration: 300.ms);

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return TransItem(
                    data.docs[index].data(),
                    data.docs[index].id,
                    onDeletePurchase: (id) => deletePurchase(id),
                  ).animate()
                  .fadeIn(duration: 200.ms, delay: 50.ms)
                  // .move(begin: const Offset(-48, 0), curve: Curves.easeOutQuad)
                  .flipV(begin: 0.7, duration: 250.ms, delay: 50.ms, curve: Curves.easeOutQuad);
                },
              );

              // return SafeArea(
              //   child: AnimatedList(
              //     initialItemCount: data.docs.length,
              //     itemBuilder: (context, index, animation) {
              //       return SlideTransition(
              //         position: animation.drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              //         .chain(CurveTween(curve: Curves.ease))),
              //         child: TransItem(
              //           data.docs[index].data(),
              //           data.docs[index].id,
              //           onDeletePurchase: (id) => deletePurchase(id),
              //         ));
              //     },
              // ));

              // return ListView(
              //   children: [...tabInfoItems],
              // );
            },
          ),
        )
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFA6D3A0),
        strokeWidth: 6.0,
      ),
    );
  }
}
