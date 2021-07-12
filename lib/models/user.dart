import 'package:mobdev_game_project/models/question.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class User extends ParseUser {
  static const String _keyTableName = 'User';

  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyEmail = 'email';
  static const String keyCorrectQs = 'correctQs';
  static const String keyIncorrectQs = 'incorrectQs';
  static const String keyTimeoutQs = 'timeoutQs';
  static const String keyHearts = 'hearts';
  static const String keyMoney = 'money';
  static const String keyPoints = 'points';

  User(String? username, String? password, String? emailAddress)
      : super(username, password, emailAddress);

  int get hearts => get<int>(keyHearts)!;

  set hearts(int value) => set<int>(keyHearts, value);

  int get money => get<int>(keyMoney)!;

  set money(int value) => set<int>(keyMoney, value);

  int get points => get<int>(keyPoints)!;

  set points(int value) => set<int>(keyPoints, value);

  List<Question> get correctQs => get<List<Question>>(keyCorrectQs)!;

  set correctQs(List<Question> value) =>
      set<List<Question>>(keyCorrectQs, value);

  List<Question> get incorrectQs => get<List<Question>>(keyIncorrectQs)!;

  set incorrectQs(List<Question> value) =>
      set<List<Question>>(keyIncorrectQs, value);

  List<Question> get timeoutQs => get<List<Question>>(keyTimeoutQs)!;

  set timeoutQs(List<Question> value) =>
      set<List<Question>>(keyTimeoutQs, value);
}
