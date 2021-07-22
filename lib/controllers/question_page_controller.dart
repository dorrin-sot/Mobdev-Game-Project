import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/clock_controller.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

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

    for (int i = 0; i < 4; i++) {
      if (index == i) {
        if (index == _correctAnswer.value) {
          _colorSwitch[i] = ColorSwitch.CORRECT;
        } else if (!timeIsUp) {
          _colorSwitch[i] = ColorSwitch.WRONG;
        }
      } else if (i == _correctAnswer.value) {
        _colorSwitch[i] = ColorSwitch.CORRECT;
      }
    }
  }

  Future<List<Question>?> fetchQuestions(Subject subject) async {
    questions = await Question.getQsFromDBForQuiz(subject);
    print('res = ${questions!.toList().toString()}');
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
