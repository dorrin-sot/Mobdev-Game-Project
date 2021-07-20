import 'package:parse_server_sdk/parse_server_sdk.dart';

class Subject extends ParseObject {
  static const String _keyTableName = 'Subject';

  static const String keyName = 'name';
  String? name;

  Subject({this.name}) : super(_keyTableName);

  factory Subject.forParse(ParseObject parseObj) =>
      Subject(name: parseObj.get(keyName))..objectId = parseObj.objectId;

  static Future<Subject> getFromDB(String subjectName) =>
      (QueryBuilder<ParseObject>(Subject())..whereEqualTo(keyName, subjectName))
          .find()
          .then((subjectList) {
        assert(subjectList.isNotEmpty);
        return Subject.forParse(subjectList.first);
      });

  static Future<List<Subject>> getAllFromDB() =>
      (QueryBuilder<ParseObject>(Subject())).find().then((subjectList) =>
          subjectList.map((parseObj) => Subject.forParse(parseObj)).toList());

  @override
  String toString() {
    return 'Subject{name: $name}';
  }
}
