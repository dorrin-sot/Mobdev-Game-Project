import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/models/user.dart';
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
      {required String subjectName, int numberOfQs = QUESTIONS_IN_QUIZ}) async {
    final controller = Get.find<AppController>();

    assert(controller.currentUser != null);
    final curUserQuestions = controller.currentUser!.allQuestions;

    final subject = await Subject.getFromDB(subjectName);

    return (QueryBuilder<ParseObject>(Question())
          ..whereEqualTo(keySubject, subject.objectId)
          ..whereNotContainedIn('objectId', curUserQuestions)
          ..setLimit(numberOfQs))
        .find()
        .then((parseQuestions) => (parseQuestions..shuffle())
            .map((ParseObject p) => Question.forParse(p))
            .toList());
  }

  // if answer is null means user ran out of time otherwise check if answer was correct
  // returns if answer was correct or not as a bool (returns false if out of time)
  bool answerQ({int? answer}) {
    final c = Get.find<AppController>();
    final curUser = c.currentUser!;
    if (answer == null) {
      curUser.addTimeoutQs(this);
      curUser.useHeart();
      curUser.save();
      save();
      return false;
    }

    if (this.correctAns == answer) {
      curUser.addCorrectQ(this);
      curUser.setIncrement(User.keyPoints, 1); // add a point if answered correct fixme: maybe give more than one point
      curUser.save();
      save();
      return true;
    } else {
      curUser.addIncorrectQ(this);
      curUser.useHeart();
      curUser.save();
      save();
      return false;
    }
  }
}
