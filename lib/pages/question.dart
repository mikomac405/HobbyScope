import 'package:flutter/material.dart';
import 'package:hobbyscope/backend.dart';
import 'package:hobbyscope/utils.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

enum PageState { loading, displayingQuestion, submitting, displayingResponse }

class _QuestionPageState extends State<QuestionPage> {
  QuestionsAndAnswers? qna;
  PageState currentState = PageState.loading;
  String response = "";
  bool _isFetchingQuestions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetchingQuestions) {
      _isFetchingQuestions = true;
      fetchQuestions();
    }
  }

  void fetchQuestions() async {
    // Fetch the questions using the context
    List<Question> questions = await getQuestions(context);
    setState(() {
      qna = QuestionsAndAnswers(questions);
      currentState = PageState.displayingQuestion;
    });
  }

  void updateAnswer(double value, BuildContext context) async {
    setState(() {
      qna!.answer(value);
    });

    if (qna!.complete) {
      setState(() {
        currentState = PageState.submitting;
      });

      // Submit the answers and get the response
      String result = await submitQuestion(context, qna!.answers);

      setState(() {
        response = result;
        currentState = PageState.displayingResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (currentState) {
      case PageState.loading:
        bodyContent = const Center(child: CircularProgressIndicator());
        break;
      case PageState.displayingQuestion:
        bodyContent = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(qna!.questions[qna!.index].question),
            ElevatedButton(
                onPressed: () => updateAnswer(1.0, context),
                child: const Text("Yes")),
            ElevatedButton(
                onPressed: () => updateAnswer(0.75, context),
                child: const Text("Maybe yes")),
            ElevatedButton(
                onPressed: () => updateAnswer(0.5, context),
                child: const Text("I don't know")),
            ElevatedButton(
                onPressed: () => updateAnswer(0.25, context),
                child: const Text("Maybe no")),
            ElevatedButton(
                onPressed: () => updateAnswer(0.0, context),
                child: const Text("No")),
          ],
        );
        break;
      case PageState.submitting:
        bodyContent = const Center(child: CircularProgressIndicator());
        break;
      case PageState.displayingResponse:
        bodyContent = Center(child: Text(response));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(qna != null ? "Question ${qna!.index + 1}" : "Loading..."),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: bodyContent,
        ),
      ),
    );
  }
}
