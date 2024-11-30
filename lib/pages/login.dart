import '../backend.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: const Text("Login"),
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
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/recovery');
                    },
                    child: const Text("Forgot Password")),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Register")),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    login(
                        context, emailController.text, passwordController.text);
                  },
                  child: const Text("Login"),
                )
              ],
            ),
          ),
        ));
  }
}
