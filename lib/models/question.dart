import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Question extends ParseObject implements ParseCloneable {
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

  Question.clone() : this();

  factory Question.fromJson(Map<String, dynamic> json, subject) => Question(
        question: json[keyQuestion],
        answers: json[keyAnswers].toString().getList(),
        correctAns: json[keyCorrectAns],
        subject: subject,
      )..objectId = json['objectId'];

  static Future<List<Question>> getQsFromDBForQuiz(Subject subject,
      {int numberOfQs = QUESTIONS_IN_QUIZ}) async {
    final c = Get.find<AppController>();
    assert(c.currentUser != null);

    final curUser = c.currentUser!;

    final query = QueryBuilder<ParseObject>(Question())
      ..whereMatchesQuery(
          keySubject,
          QueryBuilder<ParseObject>(Subject())
            ..whereEqualTo(Subject.keyName, subject.name))
      ..whereDoesNotMatchKeyInQuery(
          'objectId', 'objectId',
          QueryBuilder<ParseObject>(Question())
            ..whereRelatedTo(User.keyAllQuestions, '_User', curUser.objectId!))
      ..setLimit(numberOfQs);

    return query.query().then((response) async {
      final allQList = <Question>[];
      for (ParseObject parseQ in response.results!)
        allQList.add(Question.fromJson(parseQ.getJsonMap(), subject));

      print('question query: $allQList');
      return allQList;
    });
  }

  static Future<ParseResponse> submitResults(
      {required List<Question> quizQs,
      required int correctCount,
      required int incorrectCount,
      required int timeoutCount}) async {
    final currentUser = Get.find<AppController>().currentUser!;
    print('submit result user : $currentUser');

    for (var q in quizQs) currentUser.addQuestion(q);

    int allQCount = correctCount + incorrectCount + timeoutCount;
    int cmpPoint = correctCount + incorrectCount * -2 + timeoutCount * -1;

    return await (currentUser
          ..setIncrement(User.keyCorrectQCount, correctCount)
          ..setIncrement(User.keyIncorrectQCount, incorrectCount)
          ..setIncrement(User.keyTimeoutQCount, timeoutCount)
          ..setIncrement(
              User.keyPoints, correctCount * User.PTS_WIN_PER_CORRECT)
          ..setIncrement(User.keyMoney, cmpPoint / allQCount > 0.5 ? 1 : 0))
        .save();
  }

  @override
  String toString() {
    return 'Question{question: $question'
        ', answers: $answers'
        ', correctAns: $correctAns'
        ', subject: $subject}';
  }
}

extension GetListFromString on String {
  List<String> getList() {
    return substring(1, length - 1)
        .split(",")
        .map((e) => e.substring(0, e.length))
        .toList();
  }
}
