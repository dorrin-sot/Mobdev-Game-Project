import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
class QuizResultController extends GetxController {
  Rx<ConfettiController> _confettiController =
  ConfettiController(duration: const Duration(days: 365)).obs;
  @override
  void onInit() {
    _confettiController.value.play();
    super.onInit();
  }

  Rx<ConfettiController> get confettiController => _confettiController;
}