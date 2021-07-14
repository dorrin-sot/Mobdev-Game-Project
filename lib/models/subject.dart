import 'package:parse_server_sdk/parse_server_sdk.dart';

class Subject extends ParseObject {
  static const String _keyTableName = 'Subject';

  static const String keyName = 'name';
  String? name;

  Subject({this.name}) : super(_keyTableName);

  factory Subject.forParse(ParseObject parseObj) =>
      Subject(name: parseObj.get(keyName))..objectId = parseObj.objectId;

  String get nameDB => get<String>(keyName)!;

  set nameDB(String value) => set<String>(keyName, value);

  static Future<Subject> getFromDB(String subjectName) =>
      (QueryBuilder<ParseObject>(Subject())..whereEqualTo(keyName, subjectName))
          .first()!
          .then((parseObj) => Subject.forParse(parseObj));
}
