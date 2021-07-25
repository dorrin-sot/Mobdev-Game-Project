import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/clock_controller.dart';
import 'package:mobdev_game_project/utils/utils.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Clock extends StatelessWidget {
  static final double maxTime =29;
  final ClockController clockController = Get.put(ClockController());

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Obx(() {
          return ScaleTransition(
            scale: clockController.clockAnimationController,
            child: ClockWidget(
              seconds: clockController.dateTime.value,
            ),
          );
        }));
  }
}

class ClockWidget extends StatelessWidget {
  // final DateTime dateTime;
  final int seconds;
  const ClockWidget({Key? key, required this.seconds}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SleekCircularSlider(
      appearance: appearance03,
      min: 0,
      max: Clock.maxTime,
      initialValue: Clock.maxTime - seconds,
      innerWidget: (double value) {
        final s = Clock.maxTime.toInt() - seconds.toInt() < 10
            ? '0${Clock.maxTime.toInt() - seconds.toInt()}'
            : (Clock.maxTime.toInt() - seconds.toInt()).toString();
        return Center(
            child: Text(
              '$s',
              style: TextStyle(
                  color: HexColor('#A177B0'),
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ));
      },
    );
  }
}

final customWidth01 =
CustomSliderWidths(trackWidth: 2, progressBarWidth: 10, shadowWidth: 20);
final customColors01 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#FFD4BE').withOpacity(0.4),
    progressBarColor: HexColor('#F6A881'),
    shadowColor: HexColor('#FFD4BE'),
    shadowStep: 10.0,
    shadowMaxOpacity: 0.6);

final CircularSliderAppearance appearance01 = CircularSliderAppearance(
    customWidths: customWidth01,
    customColors: customColors01,
    startAngle: 270,
    angleRange: 360,
    size: 350.0,
    animationEnabled: false);

final customWidth02 =
CustomSliderWidths(trackWidth: 5, progressBarWidth: 15, shadowWidth: 30);
final customColors02 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#98DBFC').withOpacity(0.3),
    progressBarColor: HexColor('#6DCFFF'),
    shadowColor: HexColor('#98DBFC'),
    shadowStep: 15.0,
    shadowMaxOpacity: 0.3);

final CircularSliderAppearance appearance02 = CircularSliderAppearance(
    customWidths: customWidth02,
    customColors: customColors02,
    startAngle: 270,
    angleRange: 360,
    size: 290.0,
    animationEnabled: false);

final customWidth03 =
CustomSliderWidths(trackWidth: 2, progressBarWidth: 10, shadowWidth: 16);
final customColors03 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#EFC8FC').withOpacity(0.3),
    progressBarColor: HexColor('#A177B0'),
    shadowColor: HexColor('#EFC8FC'),
    shadowStep: 15.0,
    shadowMaxOpacity: 0.3);

final CircularSliderAppearance appearance03 = CircularSliderAppearance(
  customWidths: customWidth03,
  customColors: customColors03,
  startAngle: 270,
  angleRange: 360,
  size: 110.0,
  animationEnabled: false,

);
