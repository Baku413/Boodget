import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_header.dart';
import 'main.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final budgetRef = FirebaseFirestore.instance
      .collection('budget')
      .where(DateTime(DateTime.now().month, 1, DateTime.now().year),
          isGreaterThan: 'start_date', isLessThanOrEqualTo: 'end_date')
      .withConverter(
        fromFirestore: (snapshot, options) => Budget.fromJson(snapshot.data()!),
        toFirestore: (budget, options) => budget.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Budget>>(
              stream: budgetRef.snapshots(),
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
                  budget: data.docs[0].data(),
                );
              },
            ),
            const SizedBox(
              height: 54,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Budget History',
                    style: TextStyle(
                        color: Color(0xFFA7A7A7),
                        fontSize: 17,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 12,
              endIndent: 12,
              color: Color(0xFFA7A7A7),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const Text("history");
                },
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      //   elevation: 0,
      //   icon: const Icon(Icons.add),
      //   label: const Text('New Transaction'),
      //   backgroundColor: const Color(0xFFA6D3A0),
      //   foregroundColor: const Color(0xFFFFFFFF),
      //   tooltip: 'Add a new transaction',
      //   onPressed: () {
      //     // _incrementCounter();
      //   },
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}