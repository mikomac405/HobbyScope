import 'package:logger/logger.dart';

var logger = Logger();

class Question {
  final String question;
  final List<String> categories;

  Question(this.question, this.categories);
}

class QuestionsAndAnswers {
  final List<Question> questions;

  bool complete = false;
  bool submitInProgress = false;
  bool submitComplete = false;
  int index = 0;
  final Map<String, List<double>> answers = {
    "team_required": [],
    "sport": [],
    "intelectual": [],
    "practical": [],
    "creativity": [],
    "high_budget": [],
    "artistic": [],
    "nature": [],
    "home": [],
    "much_time_on_hobby": [],
    "adrenaline": []
  };

  QuestionsAndAnswers(this.questions);

  void answer(double value) {
    if (complete) return;

    for (var category in questions[index].categories) {
      answers[category]!.add(value);
    }
    if (index < questions.length - 1) {
      index++;
    } else {
      complete = true;
      submitInProgress = true;
      sumUp();
    }
  }

  void sumUp() {
    if (!complete) return;

    for (var answer in answers.entries) {
      if (answer.value.isEmpty) {
        answer.value.add(0.5);
      } else {
        double avg =
            (answer.value.fold(0.0, (p, c) => p + c) / answer.value.length);
        answer.value.clear();
        answer.value.add(avg);
      }
    }
  }
}
