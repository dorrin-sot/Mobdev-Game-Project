import 'package:parse_server_sdk/parse_server_sdk.dart';

class Subject extends ParseObject {
  static const String _keyTableName = 'Subject';

  static const String keyName = 'name';

  Subject() : super(_keyTableName);

  String get name => get<String>(keyName)!;

  set name(String value) => set<String>(keyName, value);
}
