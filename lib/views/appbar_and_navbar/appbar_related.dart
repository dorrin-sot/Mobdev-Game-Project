import 'dart:async';
import 'dart:math';

import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Get.put(HeartController());

    return SizedBox(
        width: 42.5,
        height: 42.5,
        child: Stack(
          children: [
            Center(
              child: GetBuilder<HeartController>(
                builder: (c) => LiquidCustomProgressIndicator(
                  value: c.currentUser.timeDoneFraction,
                  valueColor: AlwaysStoppedAnimation(Colors.red.shade300),
                  backgroundColor: Colors.white70,
                  direction: Axis.vertical,
                  shapePath: getHeartPath(Size(42.5, 42.5)),
                ),
              ),
            ),
            Center(
              child: FittedBox(
                child: GetBuilder<HeartController>(
                  builder: (c) => Text(
                    c.currentUser.hearts.toString(),
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
        ));
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
  final currentUser = Get.find<AppController>().currentUser!;

  @override
  Future<void> onInit() async {
    super.onInit();

    await currentUser.updateHearts().then((value) => scheduleUpdateHeart());
    ;
  }

  void scheduleUpdateHeart() {
    Cron().schedule(
        Schedule.parse("*/10 * * * * *"),
        () => update());
    Future.delayed(
        DateTime.now().difference(currentUser.heartsLastUpdateTime!
            .add(Duration(minutes: User.HEART_ADD_INTERVAL))),
        () => Cron().schedule(
            Schedule.parse(
                "9,19,29,39,49,59 */${User.HEART_ADD_INTERVAL} * * * *"),
            () => currentUser.updateHearts()));
  }
}

class MoneyIndicator extends StatelessWidget {
  const MoneyIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<AppController>().currentUser!;

    final c = MoneyController(currentUser.money!);
    Get.put(c);

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
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
              child: Text(
                Get.find<MoneyController>().money.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
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
  int money;

  MoneyController(this.money);

  addMoney(int amount) {
    money = max(money + amount, 0);
    update();
  }
}

class PointsIndicator extends StatelessWidget {
  const PointsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = Get.find<AppController>().currentUser!;

    final c = PointController(currentUser.points!);
    Get.put(c);

    return SizedBox(
      width: 42.5,
      height: 42.5,
      child: Stack(
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
              child: Text(
                Get.find<PointController>().points.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange.shade900,
                  fontWeight: FontWeight.bold,
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
  int points;

  PointController(this.points);
}
