import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../backend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  models.User? user;
  int currentPageIndex = 0;
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    try {
      models.User fetchedUser = await context.read<Account>().get();
      setState(() {
        user = fetchedUser;
      });
    } catch (e) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    }
  }

  Widget userInfoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Welcome, ${user?.name}"),
        const SizedBox(height: 10),
        if (!user!.emailVerification)
          const Text(
              "Please verify your account, before the profiling process."),
        const SizedBox(height: 20),
        if (!user!.emailVerification)
          ElevatedButton(
            onPressed: () {
              sendVerificationMail(context);
            },
            child: const Text("Send verification email"),
          ) else ElevatedButton(
          onPressed: () {
            //sendVerificationMail(context);
          },
          child: const Text("Look for a hobby"),
        ),
        ElevatedButton(
            onPressed: () {
              logout(context);
            },
            child: const Text("Logout"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Home"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: user == null
                ? const CircularProgressIndicator()
                : [userInfoWidget()][currentPageIndex],
          ),
        ));
  }
}
