import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hobbyscope/pages/home.dart';
import 'package:hobbyscope/pages/login.dart';
import 'package:hobbyscope/pages/recover_password.dart';
import 'package:hobbyscope/pages/register.dart';
import 'package:provider/provider.dart';


Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client.setProject(dotenv.env['PROJECT_ID']);

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final Client client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Account>(create: (context) => Account(client)),
        Provider<Storage>(create: (context) => Storage(client))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/recovery': (context) => const RecoverPasswordPage()
        },
        //home: const MyHomePage(title: 'Login'),
      ),
    );
  }
}
