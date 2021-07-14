import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class Question extends ParseObject {
  static const String _keyTableName = 'Question';

  static const String keyQuestion = 'question';
  static const String keyAnswers = 'answers';
  static const String keyCorrectAns = 'correctAns';
  static const String keySubject = 'subject';
  String? question;
  List<String>? answers;
  int? correctAns;
  Subject? subject;

  static const QUESTIONS_IN_QUIZ = 20;

  Question({this.question, this.answers, this.correctAns, this.subject})
      : super(_keyTableName);

  factory Question.forParse(ParseObject parseObj) => Question(
      question: parseObj.get(keyQuestion),
      answers: parseObj.get(keyAnswers),
      correctAns: parseObj.get(keyCorrectAns),
      subject: parseObj.get(keySubject))
    ..objectId = parseObj.objectId;

  static Future<List<Question>> getQsFromDBForQuiz(
      {int numberOfQs = QUESTIONS_IN_QUIZ}) {
    final controller = Get.find<AppController>();

    assert(controller.currentUser != null);
    final curUserQuestions = controller.currentUser!.allQuestions;

    return (QueryBuilder<ParseObject>(Question())
          ..whereNotContainedIn('objectId', curUserQuestions))
        .find()
        .then((parseQuestions) => (parseQuestions
              ..shuffle()
              ..sublist(0, numberOfQs - 1))
            .map((ParseObject p) => Question.forParse(p))
            .toList());
  }
}
