import 'package:mobdev_game_project/models/question.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UserStat extends ParseObject {
  static const String _keyTableName = 'UserStats';

  static const String keyQuestion = 'question';
  static const String keyStatus = 'status';

  Question? question;
  // Status? status;

  UserStat(String className) : super(className);
}
//
// enum Status {
//   CORRECT, INCORRECT, TIMEOUT;
//
//   get int val;
// }