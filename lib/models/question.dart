
import 'dart:math';

import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:mobdev_game_project/models/user_stats.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tuple/tuple.dart';

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

  static const QUESTIONS_IN_QUIZ = 3;

  Question({this.question, this.answers, this.correctAns, this.subject})
      : super(_keyTableName);

  Question.clone() : this();

  static Future<Question> fromJsonn(Map<String, dynamic> json, {Subject? subject}) async {
    if (subject == null) {
      final subjectObjId = json[Question.keySubject]['objectId'];
      final subjectParseResponse = await Subject().getObject(subjectObjId);
      final subjectMap = (subjectParseResponse.result as ParseObject).getJsonMap();
      subject = Subject.fromJson(subjectMap);
    }
    return Question(
        question: json[keyQuestion],
        answers: json[keyAnswers].toString().getList(),
        correctAns: json[keyCorrectAns],
        subject: subject,
      )..objectId = json['objectId'];
  }

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
      if (!response.success || response.results == null)
        return allQList;

      for (ParseObject parseQ in response.results!)
        allQList.add(
            await Question.fromJsonn(parseQ.getJsonMap(), subject: subject));

      print('question query: $allQList');
      return allQList..shuffle();
    });
  }

  static Future<ParseResponse> submitResults(
      {required List<Question> quizQs,
      required int correctCount,
      required int incorrectCount,
      required int timeoutCount}) async {
    final currentUser = Get.find<AppController>().currentUser!;
    print('submit result user : $currentUser');

    // fixme in future record this in question page controller only and pass in to function or maybe a list userstats from begining
    final statusList = List.filled(correctCount, Status.correct.val, growable: true)
      ..addAll(List.filled(incorrectCount, Status.incorrect.val))
      ..addAll(List.filled(timeoutCount, Status.timeout.val));

    for (int i = 0; i < quizQs.length; i++) {
      var question = quizQs[i];

      // add to stats results
      final status = StatusGetters.getStatus(statusList[i]);
      await currentUser.addQuestion(question, status);
    }

    int allQCount = correctCount + incorrectCount + timeoutCount;
    int cmpPoint = correctCount * 3 + incorrectCount * -2 + timeoutCount * -1;

    final response = await (currentUser
          ..setIncrement(User.keyCorrectQCount, correctCount)
          ..setIncrement(User.keyIncorrectQCount, incorrectCount)
          ..setIncrement(User.keyTimeoutQCount, timeoutCount)
          ..setIncrement(
              User.keyPoints, correctCount * User.PTS_WIN_PER_CORRECT)
          ..setIncrement(
              User.keyMoney,
              max((cmpPoint / allQCount * QUESTIONS_IN_QUIZ).floor(), 0) *
                  User.MONEY_WIN_PER_25_PERC))
        .save();

    Get.find<MoneyController>().money.value = currentUser.money!;
    Get.find<PointController>().points.value = currentUser.points!;

    return response;
  }

  // 1st item in result is the randomized result's correct answer (from 1 to 4)
  // 2nd               is the randomized result's answer list
  Tuple2<int, List<String>> randomizeAnswers() {
    final randAnsIndexList = Iterable<int>.generate(4).toList()..shuffle();

    final randCorrectAns = 1 + randAnsIndexList.indexOf(correctAns! - 1);
    final randAnsesList = randAnsIndexList.map((i) => answers![i]).toList();

    return Tuple2<int, List<String>>(randCorrectAns, randAnsesList);
  }

  @override
  String toString() {
    return '${super.toString()}   '
        'Question{question: $question'
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
