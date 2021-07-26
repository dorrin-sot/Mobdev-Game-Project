import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:mobdev_game_project/controllers/quiz_result_controller.dart';

class QuizResultPage extends StatelessWidget {
  final int num = Get.arguments['num'],
      correct = Get.arguments['correct'],
      wrong = Get.arguments['wrong'],
      empty = Get.arguments['empty'];
  QuizResultController _quizResultController = Get.put(QuizResultController());

  //todo make this page look less like shet

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(gradient: _gradient),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex:1,child: SizedBox()),
            Expanded(
              flex: 4,
              child: PrizeStack(),
            ),
            Expanded(
              flex: 7,
              child: _resultListViewContainer(_themeData),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: FittedBox(
                  child: ElevatedButton(
                    child: Text("تامام تامام", textAlign: TextAlign.center, ),
                    onPressed: _quizResultController.onPressed,

                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _resultListViewContainer(ThemeData themeData) {
    double margin = 15.0;
    double padding = 20.0;
    double opacity = 0.2;
    return Container(
        margin: EdgeInsets.only(top: margin ,left: margin , right : margin,),
        padding: EdgeInsets.only(
          right: padding,
          top: padding,
          bottom: padding,
          left: padding + 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green.withOpacity(opacity),
        ),
        height: 50,
        child: _resultListView(themeData));
  }

  Row _rowWidget(String detail, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(count.toString()),
        Text(detail),
      ],
    );
  }

  Widget _resultListView(ThemeData themeData) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 30, fontFamily: "Traffic"),
      child: ListView(

        shrinkWrap: true,
        children: [
          Center(child: Text(":نتایج" , style: TextStyle(fontSize: 40, fontFamily: "Traffic"))),
          SizedBox(height: 15),
          _rowWidget(":تعداد کل سوالات ", num),
          SizedBox(height: 10),
          _rowWidget(" :صحیح  ", correct),
          SizedBox(height: 10),
          _rowWidget(":غلط   ", wrong),
          SizedBox(height: 10),
          _rowWidget(":خالی   ", empty),
        ],
      ),
    );
  }

  Stack PrizeStack() {
    return Stack(children: [
      Align(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/trophy.png',
          // width: Get.width / 3,
          // height: Get.width / 3,
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
          confettiController: _quizResultController.confettiController.value,
          blastDirectionality: BlastDirectionality.explosive,
          // don't specify a direction, blast randomly
          shouldLoop: true,
          // start again as soon as the animation is finished
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          // manually specify the colors to be used
          createParticlePath: drawStar, // define a custom shape/path.
        ),
      )
    ]);
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  LinearGradient _gradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Colors.teal,
      Colors.indigo,
      Colors.deepPurple,
      Colors.purple,
    ],
  );
}
