import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UserStat extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'UserStats';

  static const String keyQuestion = 'question';
  static const String keyStatus = 'status';

  Question? question;
  Status? status;

  UserStat({this.question, this.status}) : super(_keyTableName);

  UserStat.clone() : this();

  static Future<UserStat> fromJsonn(Map<String, dynamic> json) async {
    final questionObjId = json[keyQuestion]['objectId'];
    final questionParseResponse = await Question().getObject(questionObjId);
    final qMap = (questionParseResponse.result as ParseObject).getJsonMap();
    return UserStat(
      question: await Question.fromJsonn(qMap),
      status: StatusGetters.getStatus(json[keyStatus] as int),
    )..objectId = json['objectId'];
  }

  static Future<List<UserStat>> getUserStats(User user,
      {Subject? subject}) async {
    final userStatsQuery = QueryBuilder<ParseObject>(UserStat())
      ..whereRelatedTo(User.keyUserStats, '_User', user.objectId!);

    if (subject != null) {
      final questionsFromSubjectQuery = QueryBuilder<ParseObject>(Question())
        ..whereEqualTo(Question.keySubject, subject.toPointer());

      userStatsQuery.whereMatchesKeyInQuery(
          keyQuestion, 'objectId', questionsFromSubjectQuery);
    }

    final userStatsResponse = await userStatsQuery.query();
    final userStatsParseObjs = userStatsResponse.results!.cast<ParseObject>();

    final userStatsObjsList = <UserStat>[];

    for (var userStatParse in userStatsParseObjs) {
      final userStatMap = userStatParse.getJsonMap();
      userStatsObjsList.add(await UserStat.fromJsonn(userStatMap));
    }
    return userStatsObjsList;
  }

  @override
  String toString() {
    return '${super.toString()}   '
        'UserStat{question: $question'
        ', status: $status}';
  }
}

enum Status { incorrect, timeout, correct }

extension StatusGetters on Status {
  static const int INCORRECT_VAL = -1;
  static const int TIMEOUT_VAL = 0;
  static const int CORRECT_VAL = 1;

  int get val {
    switch (this) {
      case Status.incorrect:
        return INCORRECT_VAL;
      case Status.timeout:
        return TIMEOUT_VAL;
      case Status.correct:
        return CORRECT_VAL;
    }
  }

  static getStatus(int value) {
    switch (value) {
      case INCORRECT_VAL:
        return Status.incorrect;
      case CORRECT_VAL:
        return Status.correct;
      case TIMEOUT_VAL:
        return Status.timeout;
    }
  }
}
