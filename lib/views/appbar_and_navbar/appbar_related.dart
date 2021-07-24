import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/misc/custom_icons_icons.dart';
import 'package:mobdev_game_project/models/user.dart';

class CustomAppbar extends AppBar {
  static AppBar build() => AppBar(
        title: Obx(
          () => Get.find<AppController>().isLoggedIn.isFalse
              ? const Text('Quiz boy 9000')
              : signedIn(),
        ),
      );

  static Widget signedIn() => Row(
        children: [
          HeartIndicator(),
          Spacer(),
          MoneyIndicator(),
          Spacer(),
          PointsIndicator()
        ],
      );
}

class HeartIndicator extends StatelessWidget {
  const HeartIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HeartController());
    return Row(
      children: [
        InkWell(
          // onTap: _showHeartTimerDialog(),
          customBorder: CircleBorder(),
          child: SizedBox(
              width: 42.5,
              height: 42.5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Obx(
                      () => LiquidCustomProgressIndicator(
                        value: c.hearts == User.HEARTS_MAX
                            ? 1
                            : c.timeRemaining.value.inSeconds.toDouble() /
                                (User.HEART_ADD_INTERVAL * 60).toDouble(),
                        valueColor: AlwaysStoppedAnimation(Colors.red.shade300),
                        backgroundColor: Colors.white70,
                        direction: Axis.vertical,
                        shapePath: getHeartPath(Size(42.5, 42.5)),
                      ),
                    ),
                    // child: LiquidCustomProgressIndicator(
                    //   value: ,
                    //   valueColor: AlwaysStoppedAnimation(Colors.red.shade300),
                    //   backgroundColor: Colors.white70,
                    //   direction: Axis.vertical,
                    //   shapePath: getHeartPath(Size(42.5, 42.5)),
                    // ),
                  ),
                  Center(
                    child: FittedBox(
                      child: Obx(
                        () => Text(
                          c.hearts.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }

  _showHeartTimerDialog() {
    final countDownController = CountDownController();
    final c = Get.find<HeartController>();
    Get.defaultDialog(
      title: 'قلب هات',
      content: Obx(
        () => IndexedStack(
          index: c.getRemainingTime() == null ? 1 : 0,
          children: [
            CircularCountDownTimer(
              controller: countDownController,
              width: Get.width / 3,
              height: Get.width / 3,
              duration: c.getRemainingTime()!.inSeconds,
              fillColor: Colors.purple,
              ringColor: Colors.purpleAccent,
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              onComplete: () {
                if (c.getRemainingTime() != null) {
                  final currentUser = Get.find<AppController>().currentUser!;
                  currentUser.updateHearts();
                  c.hearts.value = currentUser.hearts;

                  countDownController.restart(
                      duration: User.HEART_ADD_INTERVAL * 60);
                } else
                  countDownController.pause();
              },
            ),
            Column(
              children: [
                LiquidCustomProgressIndicator(
                  value: 0.7,
                  valueColor: AlwaysStoppedAnimation(Colors.purpleAccent),
                  backgroundColor: Colors.white70,
                  direction: Axis.vertical,
                  shapePath: getHeartPath(Size(Get.width / 4, Get.width / 4)),
                ),
                Text(
                  '!!قلبات پر شدن!! مبارکه',
                  style: TextStyle(fontSize: 25, color: Colors.purple),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Path getHeartPath(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, size.height * 0.89);
    path.cubicTo(size.width / 2, size.height * 0.89, size.width * 0.44,
        size.height * 0.83, size.width * 0.44, size.height * 0.83);
    path.cubicTo(size.width * 0.23, size.height * 0.64, size.width * 0.08,
        size.height * 0.51, size.width * 0.08, size.height * 0.35);
    path.cubicTo(size.width * 0.08, size.height * 0.23, size.width * 0.18,
        size.height * 0.13, size.width * 0.31, size.height * 0.13);
    path.cubicTo(size.width * 0.39, size.height * 0.13, size.width * 0.45,
        size.height * 0.16, size.width / 2, size.height / 5);
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.62,
        size.height * 0.13, size.width * 0.69, size.height * 0.13);
    path.cubicTo(size.width * 0.82, size.height * 0.13, size.width * 0.92,
        size.height * 0.23, size.width * 0.92, size.height * 0.35);
    path.cubicTo(size.width * 0.92, size.height * 0.51, size.width * 0.78,
        size.height * 0.64, size.width * 0.56, size.height * 0.84);
    path.cubicTo(size.width * 0.56, size.height * 0.84, size.width / 2,
        size.height * 0.89, size.width / 2, size.height * 0.89);
    path.cubicTo(size.width / 2, size.height * 0.89, size.width / 2,
        size.height * 0.89, size.width / 2, size.height * 0.89);
    return path;
  }
}

class HeartController extends GetxController {
  final hearts = Get.find<AppController>().currentUser!.hearts.obs;
  final timeRemaining = Duration(minutes: User.HEART_ADD_INTERVAL).obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    // Cron().schedule(Schedule.parse('* * * * * *'), () => updateTime());

    await Get.find<AppController>()
        .currentUser!
        .updateHearts()
        .then((value) => scheduleUpdateHeart());
  }

  void scheduleUpdateHeart() {
    final currentUser = Get.find<AppController>().currentUser!;
    Cron().schedule(Schedule.parse("*/10 * * * * *"), () {
      timeRemaining.value = getRemainingTime()!;
      print('heart 10sec update result: $hearts $timeRemaining');
    });
    Future.delayed(
      DateTime.now().difference(currentUser.heartsLastUpdateTime!
          .add(Duration(minutes: User.HEART_ADD_INTERVAL))),
      () => Cron().schedule(
          Schedule.parse(
              "9,19,29,39,49,59 */${User.HEART_ADD_INTERVAL} * * * *"),
          () async {
        await currentUser.updateHearts();
        if (hearts.value != currentUser.hearts)
          hearts.value = currentUser.hearts;
      }),
    );
  }

  Duration? getRemainingTime() {
    final currentUser = Get.find<AppController>().currentUser!;
    if (currentUser.hearts! == User.HEARTS_MAX) return Duration(); // is all 0

    return currentUser.heartsLastUpdateTime!
        .add(Duration(minutes: User.HEART_ADD_INTERVAL))
        .difference(DateTime.now());
  }

  updateHeart() {
    final currentUser = Get.find<AppController>().currentUser!;
    currentUser.updateHearts();
    update();
  }
}

class MoneyIndicator extends StatelessWidget {
  const MoneyIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MoneyController());

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              CustomIcons.coins,
              size: 35,
              color: Colors.yellow.shade200,
            ),
          ),
          Center(
            child: FittedBox(
              child: Obx(
                () => Text(
                  c.money.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoneyController extends GetxController {
  final money = 0.obs;

  @override
  void onInit() {
    super.onInit();

    money.value = Get.find<AppController>().currentUser!.money!;
  }

  addMoney(int amount) {
    money.value = max(money.value + amount, 0);
    update();
  }
}

class PointsIndicator extends StatelessWidget {
  const PointsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PointController());

    return SizedBox(
      width: 42.5,
      height: 42.5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              Icons.star,
              size: 42.5,
              color: Colors.yellow,
            ),
          ),
          Center(
            child: FittedBox(
              child: Obx(
                () => Text(
                  c.points.value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepOrange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PointController extends GetxController {
  final points = 0.obs;

  @override
  void onInit() {
    super.onInit();

    points.value = Get.find<AppController>().currentUser!.points!;
  }
}
