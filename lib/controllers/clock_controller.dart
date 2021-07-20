import 'dart:async';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

class ClockController extends GetxController {
  Rx<Timer> _timer =
      Timer.periodic(const Duration(seconds: 1), (timer) {}).obs;

  Rx<Timer> get timer => _timer;

  set timer(Rx<Timer> value) {
    _timer = value;
  }

  Rx<DateTime> _dateTime = DateTime.now().obs;

  @override
  void onInit() {
    dateTime.value = DateTime.now();
    _timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      _dateTime.value = DateTime.now();
    });

    super.onInit();
  }

  @override
  void onClose() {
    _timer.value.cancel();
    super.onClose();
  }

  Rx<DateTime> get dateTime => _dateTime;

  set dateTime(Rx<DateTime> value) {
    _dateTime = value;
  }
}
