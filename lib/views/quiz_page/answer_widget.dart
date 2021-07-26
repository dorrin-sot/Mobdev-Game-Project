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
  static const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  QuestionPageController controller = Get.find<QuestionPageController>();

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Obx(() {
        return ElevatedButton(
          onPressed: controller.waiting
              ? () {}
              : () {
                  controller.prepareNextQ(index, false);
                },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                answer,
                textAlign: TextAlign.center,
                style: _themeData.textTheme.headline3!
                    .copyWith(color: Colors.black),
              ),
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              controller.colorSwitch[index].color,
            ),
            elevation: MaterialStateProperty.all(10),
            shape: MaterialStateProperty.resolveWith((states) => myResolver(states))
          ),
        );
      }),
      // color: controller.colorSwitch.color,
    );
  }
  myResolver(Set<MaterialState> states) {

    if (states.any(interactiveStates.contains)) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.zero);
    }
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(30));
  }
}
