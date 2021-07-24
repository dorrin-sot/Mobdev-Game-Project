import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/clock_controller.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:pedantic/pedantic.dart';

enum ColorSwitch { MAIN, WRONG, CORRECT }

extension ColorSwitchExtension on ColorSwitch {
  Color get color {
    switch (this) {
      case ColorSwitch.MAIN:
        return Colors.blue;
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

  bool get waiting => _waiting.value;

  set waiting(bool value) {
    _waiting.value = value;
  }

  RxList<ColorSwitch> _colorSwitch =
      List.generate(4, (index) => ColorSwitch.MAIN).obs;

  List<ColorSwitch> get colorSwitch => _colorSwitch;

  final RxInt _correctAnswer = 0.obs;

  int get correctAnswer => _correctAnswer.value;

  set correctAnswer(int value) {
    _correctAnswer.value = value;
  }

  get index => _questionIndex.value;

  set index(value) {
    _questionIndex.value = value;
  }

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
    if (_results[0] > 0) Get.find<AppController>().currentUser!.useHeart();
    else {
      // todo go back or show a dialog for if there are no more questions left in DB
    }
    return questions;
  }

  void prepareNextQ(int index, bool timeIsUp) {
    setColor(index, timeIsUp);
    Future.delayed(Duration(seconds: 2), () {
      resetForNextQOrQuit();
    });
    waiting = true;
    if (!timeIsUp) {
      ClockController controller = Get.find<ClockController>();
      controller.timer.value.cancel();
      controller.dateTime.value = 0;
    }
  }

  void resetForNextQOrQuit() {
    //todo quit function
    if (_questionIndex == questions!.length - 1) {
      int correct = _results[1], wrong = _results[2], empty = _results[3];
      unawaited(Question.submitResults(
              quizQs: questions!,
              correctCount: correct,
              incorrectCount: wrong,
              timeoutCount: empty)
          .then((response) => print('results saved')));
      Get.toNamed('/quiz-res', arguments: {
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
    controller.timer.value =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      controller.fixTime(timer);
    });
  }
}
