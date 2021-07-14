import 'package:parse_server_sdk/parse_server_sdk.dart';

class Subject extends ParseObject {
  static const String _keyTableName = 'Subject';

  static const String keyName = 'name';
  String? name;

  Subject() : super(_keyTableName);

  String get nameDB => get<String>(keyName)!;

  set nameDB(String value) => set<String>(keyName, value);

  static Future<Subject> getFromDB(String subjectName) {
    return (QueryBuilder<ParseObject>(Subject())
          ..whereEqualTo(keyName, subjectName))
        .find()
        .then((parseObject) => Subject.fromParseObject(parseObject.first));
  }

  static Subject fromParseObject(ParseObject parseObject) => Subject()
    ..name = parseObject.get<String>(keyName)
    ..objectId = parseObject.objectId;
}
