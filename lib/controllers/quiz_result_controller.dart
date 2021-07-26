import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
class QuizResultController extends GetxController {
  Rx<ConfettiController> _confettiController =
  ConfettiController(duration: const Duration(days: 365)).obs;
  @override
  void onInit() {
    _confettiController.value.play();
    AppController appController = Get.find<AppController>();
    appController.quizPlayer.stop();
    appController.player.play();

    super.onInit();
  }
  void onPressed(){
    Get.offAndToNamed("/main-pages");
  }
  Rx<ConfettiController> get confettiController => _confettiController;
}