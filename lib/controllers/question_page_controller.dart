import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

enum ColorSwitch { MAIN, WRONG, CORRECT }

extension ColorSwitchExtension on ColorSwitch {
  Color get color {
    switch (this) {
      case ColorSwitch.MAIN:
        return Colors.yellow;
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
  RxInt _pressedIndex = 0.obs;

  int get pressedIndex => _pressedIndex.value;

  set pressedIndex(int value) {
    _pressedIndex.value = value;
  }

  RxList<ColorSwitch> _colorSwitch =
      List.generate(4, (index) => ColorSwitch.MAIN).obs;

  List<ColorSwitch> get colorSwitch => _colorSwitch;

  SetColorSwitch(ColorSwitch value, index) {
    _colorSwitch[index] = value;
  }

  final RxInt _correctAnswer = 0.obs;

  int get correctAnswer => _correctAnswer.value;

  set correctAnswer(int value) {
    _correctAnswer.value = value;
  }

  get index => _questionIndex.value;

  set index(value) {
    _questionIndex.value = value;
  }

  increment() {
    _questionIndex += 1;
  }

  setColor(int index) {
    print("index: $index , ans: $_correctAnswer");
    for (int i = 0; i < 4; i++) {
      if (index == i) {
        if (index == _correctAnswer.value) {
          _colorSwitch[i] = ColorSwitch.CORRECT;
        } else {
          _colorSwitch[i] = ColorSwitch.WRONG;
        }
      } else if (i == _correctAnswer.value) {
        _colorSwitch[i] = ColorSwitch.CORRECT;
      }
    }
  }

  Future<List?> fetchQuestions(String subjectName) async {
    await Future.delayed(Duration(seconds: 2));
    questions = [
      Question(
          question: "q1",
          answers: ["ans1", "ans2", "ans3", "ans4"],
          correctAns: 1,
          subject: null),
      Question(
          question: "q2",
          answers: ["ans1", "ans2", "ans3", "ans4"],
          correctAns: 2,
          subject: null),
      Question(
          question: "q3",
          answers: ["ans1", "ans2", "ans3", "ans4"],
          correctAns: 3,
          subject: null),
      Question(
          question: "q4",
          answers: ["ans1", "ans2", "ans3", "ans4"],
          correctAns: 4,
          subject: null),
      Question(
          question: "q5",
          answers: ["ans1", "ans2", "ans3", "ans4"],
          correctAns: 1,
          subject: null),
    ];
    return questions;

    // questions = await Question.getQsFromDBForQuiz(subjectName: subjectName);
    // print("result from server: "+ questions!.toList().toString() );
    // return questions;
  }
}
