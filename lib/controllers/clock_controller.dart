import 'dart:async';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mobdev_game_project/views/queez_page/clock_widget.dart';

class ClockController extends GetxController {
  Rx<Timer> _timer =
      Timer.periodic(const Duration(seconds: 1), (timer) {}).obs;

  Rx<Timer> get timer => _timer;

  set timer(Rx<Timer> value) {
    _timer = value;
  }

  // Rx<DateTime> _dateTime = DateTime.now().obs;
  RxInt _dateTime = 0.obs;


  @override
  void onReady() {

    _timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("inside time ${_dateTime.value}");
      if(_dateTime.value == Clock.maxTime) _dateTime.value =0;
      else _dateTime.value = _dateTime.value+1;
    });
    super.onReady();
  }

  @override
  void onClose() {
    _timer.value.cancel();
    super.onClose();
  }

  RxInt get dateTime => _dateTime;

  set dateTime(RxInt value) {
    _dateTime = value;
  }
}
