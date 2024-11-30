import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> login(BuildContext context, String email, String password) async {
  try {
    await context
        .read<Account>()
        .createEmailPasswordSession(email: email, password: password);
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  } on AppwriteException catch (e) {
    logger.e("${e.code}, ${e.type}, ${e.message}");
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
}

Future<void> register(BuildContext context, String userName, String email,
    String password, String confirmPassword) async {
  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords doesn't match!")));
    return;
  }
  try {
    await context.read<Account>().create(
        userId: ID.unique(), email: email, password: password, name: userName);
    if (!context.mounted) return;
    await login(context, email, password);
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  } on AppwriteException catch (e) {
    logger.e("${e.code}, ${e.type}, ${e.message}");
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
}

Future<void> logout(BuildContext context) async {
  try {
    await context.read<Account>().deleteSession(sessionId: 'current');
  } on AppwriteException catch (_) {
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
}

Future<void> sendVerificationMail(BuildContext context) async {
  try {
    await context.read<Account>().createVerification(url: "${dotenv.env['API_ULR']}/verify");
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Email sent"),
      backgroundColor: Colors.green,
    ));
  } on AppwriteException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
}

Future<void> sendPasswordRecoveryMail(
    BuildContext context, String email) async {
  try {
    await context
        .read<Account>()
        .createRecovery(url: "${dotenv.env['API_ULR']}/recovery", email: email);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Email sent"),
      backgroundColor: Colors.green,
    ));
  } on AppwriteException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
}

Map<int, Map<String, String>> messages = {
  401: {"general_unauthorized_scope": "Unauthorized user, please log in."}
};

void getQuestions(BuildContext context) async {
  try {
    final database = context.read<Databases>();
    final response = await database.listDocuments(
      databaseId: '674b16ca0031930f86cf',
      collectionId: '674b16d2001587a19f29',
    );
    final questions = response.documents.map((doc) => doc.data['question'] as String).toList();
    print('Get question: $questions');
  }
  catch (e) {
    print('An error occured: $e');
  };

}

