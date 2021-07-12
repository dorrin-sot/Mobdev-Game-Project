import 'package:mobdev_game_project/models/subject.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class Question extends ParseObject {
  static const String _keyTableName = 'Question';

  static const String keyQuestion = 'question';
  static const String keyAnswers = 'answers';
  static const String keyCorrectAns = 'correctAns';
  static const String keySubject = 'subject';

  Question() : super(_keyTableName);

  String get question => get<String>(keyQuestion)!;

  set question(String value) => set<String>(keyQuestion, value);

  List<String> get answers => get<List<String>>(keyAnswers)!;

  set answers(List<String> value) => set<List<String>>(keyAnswers, value);

  int get correctAns => get<int>(keyCorrectAns)!;

  set correctAns(int value) => set<int>(keyCorrectAns, value);

  Subject get subject => get<Subject>(keySubject)!;

  set subject(Subject value) => set<Subject>(keySubject, value);
}
