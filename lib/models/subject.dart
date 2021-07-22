import 'package:mobdev_game_project/main.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Subject extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'Subject';

  static const String keyName = 'name';
  String? name;

  Subject({this.name}) : super(_keyTableName);

  Subject.clone() : this();

  factory Subject.fromJson(Map<String, dynamic> json) =>
      Subject(name: json[keyName])..objectId = json['objectId'];

  @override
  clone(Map<String, dynamic> map) => Subject.clone()..fromJson(map);

  static Future<Subject> getFromDB(String subjectName) =>
      (QueryBuilder<ParseObject>(Subject())..whereEqualTo(keyName, subjectName))
          .find()
          .then((subjectList) {
        assert(subjectList.isNotEmpty);
        return Subject.fromJson(subjectList.first.getJsonMap());
      });

  static Future<List<Subject>> getAllFromDB() =>
      (QueryBuilder<ParseObject>(Subject()))
          .find()
          .then((subjectList) => subjectList.map((parseObj) {
                print('subject = ${parseObj.getJsonMap()}');
                return Subject.fromJson(parseObj.getJsonMap());
              }).toList());

  @override
  String toString() {
    return '${super.toString()}   Subject{name: $name}';
  }
}
