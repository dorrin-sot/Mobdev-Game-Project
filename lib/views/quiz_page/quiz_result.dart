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
    return Container(
      decoration: BoxDecoration(gradient: _gradient),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: PrizeStack(),
            ),
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
