import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/views/quiz_page/clock_widget.dart';

class ClockController extends GetxController with SingleGetTickerProviderMixin {
  Rx<Timer> _timer = Timer.periodic(const Duration(seconds: 1), (timer) {}).obs;
  int millisecondsForAnimation = 2000;
  late DateTime startDateTime;
  double alpha =0.001;
  late final AnimationController _clockAnimationController =
      AnimationController(
    duration: Duration(milliseconds: millisecondsForAnimation),
    vsync: this,
  )..repeat(reverse: true).obs;
  AppController _appController = Get.find<AppController>();
  AnimationController get clockAnimationController => _clockAnimationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _clockAnimationController,
    curve: Curves.elasticOut,
  );

  Rx<Timer> get timer => _timer;

  set timer(Rx<Timer> value) {
    _timer = value;
  }

  int getMill() {
    return 2000 - DateTime.now().difference(startDateTime).inMilliseconds ~/ 17;
  }

  // Rx<DateTime> _dateTime = DateTime.now().obs;
  RxInt _dateTime = 0.obs;

  @override
  void onInit() {
    print("clock_controller, onInit ");

    _appController.player.stop();
    _appController.quizPlayer.play();
    //todo fix speed of music

    super.onInit();
  }

  @override
  void onReady() {
    print("clock_Controller, onReady ");
    repeatedSettingOffAnimationAndClock();
    super.onReady();
  }
  repeatedSettingOffAnimationAndClock(){
    startDateTime = DateTime.now();
    millisecondsForAnimation =2000;

    _timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(millisecondsForAnimation <1000)
      _appController.quizPlayer.setSpeed(1+alpha*(1000-millisecondsForAnimation)/2);
      print("timer for clock_controller");
      millisecondsForAnimation = getMill();
      _clockAnimationController.duration =
          Duration(milliseconds: millisecondsForAnimation);
      // if (_clockAnimationController.isAnimating)
        _clockAnimationController.repeat();
      // else _clockAnimationController.reset()

      // print("controller ${_clockAnimationController.duration!.inMilliseconds} but millies: $millisecondsForAnimation");
      setClockWidgetTime();
    });
  }
  setClockWidgetTime() {
    // print("inside time ${_dateTime.value}");
    if (_dateTime.value == Clock.maxTime) {
      QuestionPageController questionPageController =
          Get.find<QuestionPageController>();
      questionPageController.prepareNextQ(-1, true);
      _dateTime.value = 0;
      clockAnimationController.stop();
      if (questionPageController.waiting) _timer.value.cancel();
    } else
      _dateTime.value = _dateTime.value + 1;
  }

  @override
  void onClose() {
    print("clock_controller, onClose ");
    AppController appController = Get.find<AppController>();
    _appController.quizPlayer.setSpeed(1);

    appController.quizPlayer.stop();
    appController.player.play();

    _timer.value.cancel();
    super.onClose();
  }


  RxInt get dateTime => _dateTime;

  set dateTime(RxInt value) {
    _dateTime = value;
  }
}
