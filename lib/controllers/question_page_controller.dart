import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/clock_controller.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:pedantic/pedantic.dart';

enum ColorSwitch { MAIN, WRONG, CORRECT }

extension ColorSwitchExtension on ColorSwitch {
  Color get color {
    switch (this) {
      case ColorSwitch.MAIN:
        return Colors.orange.shade50;
      case ColorSwitch.WRONG:
        return Colors.red;
      case ColorSwitch.CORRECT:
        return Colors.green;
    }
  }
}

class QuestionPageController extends GetxController {
  List<Question>? questions = <Question>[].obs;
  Question? currentQuestion = null;
  RxInt _questionIndex = 0.obs;
  RxBool _waiting = false.obs;
  RxList<int> _results = [0, 0, 0, 0].obs;
  RxList<ColorSwitch> _colorSwitch =
      List.generate(4, (index) => ColorSwitch.MAIN).obs;
  final RxInt _correctAnswer = 0.obs;

  setColor(int index, bool timeIsUp) {
    print("index: $index , ans: $_correctAnswer");
    if (timeIsUp) _results[3]++;
    for (int i = 0; i < 4; i++) {
      if (index == i) {
        if (index == _correctAnswer.value) {
          _results[1]++;
          _colorSwitch[i] = ColorSwitch.CORRECT;
        } else if (!timeIsUp) {
          _results[2]++;
          _colorSwitch[i] = ColorSwitch.WRONG;
        }
      } else if (i == _correctAnswer.value) {
        _colorSwitch[i] = ColorSwitch.CORRECT;
      }
    }
  }

  Future<List<Question>?> fetchQuestions(Subject subject) async {
    questions = await Question.getQsFromDBForQuiz(subject);
    _results[0] = questions!.length;
    print('res = ${questions!}');
    if (_results[0] > 0)
      Get.find<HeartController>().currentUser.useHeart();
    return questions;
  }

  void prepareNextQ(int index, bool timeIsUp) {
    setColor(index, timeIsUp);
    Future.delayed(Duration(seconds: 2), () {
      resetForNextQOrQuit();
    });
    waiting = true;
    Get.find<AppController>().quizPlayer.setSpeed(1);

    if (!timeIsUp) {
      ClockController controller = Get.find<ClockController>();
      controller.timer.value.cancel();
      controller.clockAnimationController.stop();
      controller.dateTime.value = 0;
    }
  }

  void resetForNextQOrQuit() {
    if (_questionIndex == questions!.length - 1) {
      int correct = _results[1], wrong = _results[2], empty = _results[3];
      unawaited(Question.submitResults(
              quizQs: questions!,
              correctCount: correct,
              incorrectCount: wrong,
              timeoutCount: empty)
          .then((response) => print('results saved')));
      Get.offAndToNamed('/quiz-res', arguments: {
        'num': _results[0],
        'correct': correct,
        'wrong': wrong,
        'empty': empty
      });
      return;
    }
    _questionIndex += 1;
    correctAnswer = questions![index].correctAns! - 1;
    _colorSwitch.value = List.filled(4, ColorSwitch.MAIN);
    _waiting.value = false;
    ClockController controller = Get.find<ClockController>();
    controller.repeatedSettingOffAnimationAndClock();
  }

  bool get waiting => _waiting.value;

  set waiting(bool value) {
    _waiting.value = value;
  }

  List<ColorSwitch> get colorSwitch => _colorSwitch;

  int get correctAnswer => _correctAnswer.value;

  set correctAnswer(int value) {
    _correctAnswer.value = value;
  }

  get index => _questionIndex.value;

  set index(value) {
    _questionIndex.value = value;
  }

// questions=[
//   Question(subject: subject ,correctAns: 2,answers: ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","ssssssssssssssssssssssssssssssss2","ssssssssssssssssssssssssss3","سلام به همه ی بجچ ها های ایران بدثاخنلئکملدرشبیبیشبیشبیشبیشبل"],question: "is this fucked up?"),
//   Question(subject: subject ,correctAns: 2,answers: ["1","2","3","4"],question: "is this fucked up?"),
//   Question(subject: subject ,correctAns: 2,answers: ["1","2","3","4"],question: "is this fucked up?"),
//   // Question(subject: subject ,correctAns: 2,answers: ["1","2","3","4"],question: "is this fucked up?"),
//   // Question(subject: subject ,correctAns: 2,answers: ["1","2","3","4"],question: "is this fucked up?"),
// ];
}
