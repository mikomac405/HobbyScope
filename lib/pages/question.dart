import 'package:flutter/material.dart';
import 'package:hobbyscope/backend.dart';
import 'package:hobbyscope/utils.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

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
    //List<Question> questions = await getQuestions(context);

    List<Question> mockQuestions = [
      Question("Czy lubisz programować?", ["intelectual"]),
      Question("Czy lubisz sport?", ["sport"]),
      Question("Czy lubisz rysować?", ["artistic"]),
    ];

    setState(() {
      qna = QuestionsAndAnswers(mockQuestions); //questions
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
      // String result = await submitQuestion(context, qna!.answers);

      String result = "Twoje hobby to: Skakanie wśród jednorożców"; //result

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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(qna!.questions[qna!.index].question,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20), //
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => updateAnswer(1.0, context),
              child: const Text("Tak"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => updateAnswer(0.75, context),
              child: const Text("Raczej tak"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => updateAnswer(0.5, context),
              child: const Text("Nie wiem"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => updateAnswer(0.25, context),
              child: const Text("Raczej nie"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => updateAnswer(0.0, context),
              child: const Text("Nie"),
            ),
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
