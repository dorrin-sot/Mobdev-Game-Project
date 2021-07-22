import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizResultPage extends StatelessWidget {
  final int num = Get.arguments['num'],
      correct = Get.arguments['correct'],
      wrong = Get.arguments['wrong'],
      empty = Get.arguments['empty'];
  //todo make this page look less like shet

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: Icon(Icons.find_in_page_rounded)),
          Expanded(flex: 1, child: Text("نتایج: ")),
          Expanded(
            flex: 7,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text("تعداد کل سوالات: " + num.toString()),
                ),
                Center(
                  child: Text("صحیح: " + correct.toString()),
                ),
                Center(
                  child: Text("غلط: " + wrong.toString()),
                ),
                Center(
                  child: Text("خالی: " + empty.toString()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
