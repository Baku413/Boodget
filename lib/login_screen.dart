import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: 'Email');
  TextEditingController pwController = TextEditingController(text: 'Password');

  Future<UserCredential> loginToFirebase(String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          TextField(
            controller: emailController,
          ),
          TextField(
            controller: pwController,
          ),
          TextButton(
              onPressed: () {
                loginToFirebase(emailController.text, pwController.text)
                    .then((value) {
                  print('User: ${value.user}');
                  Navigator.pushNamed(context, '/')
                      .onError((error, stackTrace) => print('Error: $error'));
                });
              },
              child: const Text('Submit'))
        ],
      ),
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}
