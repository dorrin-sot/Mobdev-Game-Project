import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  final int num , correct, wrong , empty;
  //todo make this page look less like shet
  QuizResultPage(this.num, this.correct, this.wrong, this.empty);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2,child: Icon(Icons.find_in_page_rounded)),
          Expanded(flex: 1,child: Text("نتایج: ")),
          Expanded(
            flex: 7,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(child: Text("تعداد کل سوالات: " + num.toString())),
                Center(child: Text("صحیح: " + correct.toString())),
                Center(child: Text("غلط: " + wrong.toString())),
                Center(child: Text("خالی: " + empty.toString())),
              ],
            ),
          )
        ],
      ),
    );
  }
}
