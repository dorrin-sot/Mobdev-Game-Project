import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';

class AnswerWidget extends StatelessWidget {
  final String answer;
  final int index;

  AnswerWidget(
    this.answer,
    this.index,
  );

  QuestionPageController controller = Get.find<QuestionPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return ElevatedButton(
          onPressed: controller.waiting
              ? null
              : () {
                  controller.setColor(index);
                  print("statrt");
                  Future.delayed(Duration(seconds: 2), () {
                    controller.increment();
                    controller.reset();
                  });
                  print("end");
                  controller.waiting = true;
                },
          child: Text(
            answer,
            textAlign: TextAlign.center,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  controller.colorSwitch[index].color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ))),
        );
      }),
      // color: controller.colorSwitch.color,
    );
  }
}
