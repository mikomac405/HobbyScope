import 'package:flutter/material.dart';
import '../backend.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          title: const Text("Password recovery"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder() , labelText: 'Email'),
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go back to login page")),
                const SizedBox(height: 10),
                FilledButton(
                    onPressed: () {
                      sendPasswordRecoveryMail(context, emailController.text);
                    },
                    child: const Text("Send password recovery link")),

              ],
            ),
          ),
        ));
  }
}
