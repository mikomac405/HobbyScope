import 'dart:async';
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String apiUrl = dotenv.env['API_ULR']!;
String databaseId = dotenv.env['DATABASE_ID']!;
String answerCollectionId = dotenv.env['ANSWER_COLLECTION_ID']!;
String questionCollectionId = dotenv.env['QUESTIONS_COLLECTION_ID']!;
String functionId = dotenv.env["FUNCTION_ID"]!;

// Future<void> login(BuildContext context, String email, String password) async {
//   try {
//     await context
//         .read<Account>()
//         .createEmailPasswordSession(email: email, password: password);
//     if (!context.mounted) return;
//     Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
//   } on AppwriteException catch (e) {
//     logger.e("${e.code}, ${e.type}, ${e.message}");
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.message!)));
//   }
// }

void login(BuildContext context, String email, String password) {
  if (email == "test@example.com" && password == "zaq1@WSX") {
    Navigator.pushNamed(context, '/');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password!")));
  }
}

Future<void> register(BuildContext context, String userName, String email,
    String password, String confirmPassword) async {
  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords doesn't match!")));
    return;
  }
  // try {
  //   await context.read<Account>().create(
  //       userId: ID.unique(), email: email, password: password, name: userName);
  //   if (!context.mounted) return;
  //   await login(context, email, password);
  //   if (!context.mounted) return;
  //   Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  // } on AppwriteException catch (e) {
  //   logger.e("${e.code}, ${e.type}, ${e.message}");
  //   if (!context.mounted) return;
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(e.message!)));
  // }
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
    await context.read<Account>().createVerification(url: "$apiUrl/verify");
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
        .createRecovery(url: "$apiUrl/recovery", email: email);
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

FutureOr<List<Question>> getQuestions(BuildContext context) async {
  try {
    final database = context.read<Databases>();
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: questionCollectionId,
    );

    // Organize questions by their order
    Map<int, List<Question>> questionsByOrder = {};

    for (var doc in response.documents) {
      var q = doc.data['question'] as String;
      var l_cat = doc.data['categories']
          .map<String>((item) => item.toString())
          .toList();
      var order = doc.data['order'] as int;

      if (!questionsByOrder.containsKey(order)) {
        questionsByOrder[order] = [];
      }

      questionsByOrder[order]!.add(Question(q, l_cat));
    }

    // Randomly pick one question for each order
    List<Question> selectedQuestions = [];
    Random random = Random();

    for (int i = 1; i <= 5; i++) {
      if (questionsByOrder.containsKey(i) && questionsByOrder[i]!.isNotEmpty) {
        // Pick a random question for the current order
        var randomIndex = random.nextInt(questionsByOrder[i]!.length);
        selectedQuestions.add(questionsByOrder[i]![randomIndex]);
      } else {
        // Handle case where no questions exist for an order
        throw Exception('No questions found for order $i');
      }
    }

    return selectedQuestions;
  } on AppwriteException catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
    rethrow;
  }
}

Future<String> submitQuestion(
    BuildContext context, Map<String, List<double>> qna) async {
  try {
    final user = await context.read<Account>().get();
    final database = context.read<Databases>();

    final docs = await database.listDocuments(
        databaseId: databaseId,
        collectionId: answerCollectionId,
        queries: [
          Query.equal("user_id", [user.$id])
        ]);

    Map<String, dynamic> answers =
        qna.map((key, value) => MapEntry(key, value.first));
    if (docs.total == 1) {
      database.updateDocument(
          databaseId: databaseId,
          collectionId: answerCollectionId,
          documentId: docs.documents[0].$id,
          data: answers);
    } else {
      answers.addEntries([MapEntry("user_id", user.$id)]);
      database.createDocument(
          databaseId: databaseId,
          collectionId: answerCollectionId,
          documentId: ID.unique(),
          data: answers);
    }

    var ans = await context.read<Functions>().createExecution(
        functionId: functionId,
        headers: {"Content-Type": "application/json"},
        body: '{"user_id": "${user.$id}"}',
        method: ExecutionMethod.gET);
    return ans.responseBody;
  } on AppwriteException catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
  return "";
}
