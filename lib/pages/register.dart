import '../backend.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Register"),
          automaticallyImplyLeading: false,
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
                      border: OutlineInputBorder(), labelText: 'Username'),
                  controller: userNameController,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm password'),
                  controller: passwordConfirmController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go back to login page")),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: () {
                      register(
                          context,
                          userNameController.text,
                          emailController.text,
                          passwordController.text,
                          passwordConfirmController.text);
                    },
                    child: const Text("Register"))
              ],
            ),
          ),
        ));
  }
}
