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
    ThemeData _themeData = Theme.of(context);
    return Container(
      child: Obx(() {
        return ElevatedButton(
          onPressed: controller.waiting
              ? () {}
              : () {
                  controller.prepareNextQ(index, false);
                },
          child: Text(
            answer,
            textAlign: TextAlign.center,
          ),
          style: _themeData.elevatedButtonTheme.style!.copyWith(
            backgroundColor:
                MaterialStateProperty.all(controller.colorSwitch[index].color),
          ),
        );
      }),
      // color: controller.colorSwitch.color,
    );
  }
}
