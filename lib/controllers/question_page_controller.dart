import 'package:get/get.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class QuestionPageController extends GetxController {
  // final _questions = Future.value(<dynamic>[]).obs;
  final _questions = <dynamic>[].obs;
  final _answers = <dynamic>[].obs;
  final RxInt _correctAnswer = 0.obs;
  get questions => _questions;



  RxInt _questionIndex = 0.obs;


  get index => _questionIndex;

  set index(value) {
    _questionIndex = value;
  }
  increment() {
    _questionIndex +=1;
  }
  Future<List> fetchQuestions() async {
    // await Future.delayed(Duration(seconds: 2));
    // return Future.value()
    QueryBuilder<ParseObject> queryQuestions =
    QueryBuilder<ParseObject>(ParseObject('Question'));
    final ParseResponse apiResponse = await queryQuestions.query();

    if (apiResponse.success && apiResponse.results != null) {
      // _questions.value = Future.value(apiResponse.results);
      for(int i =0 ; i<apiResponse.results!.length;i++){
        _questions.add(apiResponse.results![i].get<String>('question'));
      }
      return Future.value(apiResponse.results);
    } else {
      print(apiResponse.error);
      throw new Exception("be ga raftim");
    }
  }


}
