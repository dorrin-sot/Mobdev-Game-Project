import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mobdev_game_project/models/app_controller.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class CustomAppbar extends AppBar {
  static AppBar build() {
    return AppBar(
      title: GetBuilder<AppController>(
        builder: (c) => FutureBuilder<User>(
          future:
              ParseUser.currentUser().then((parseUser) => parseUser as User),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Quiz boy 9000');
            }
            return signedIn(currentUser: snapshot.data!);
          },
        ),
      ),
    );
  }

  static Widget signedIn({required User currentUser}) => Row(
        children: [
          HeartIndicator(currentUser: currentUser),
          MoneyIndicator(currentUser: currentUser),
          PointsIndicator(currentUser: currentUser)
        ],
      );
}

class HeartIndicator extends StatelessWidget {
  final User currentUser;

  const HeartIndicator({required this.currentUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = HeartController(currentUser.minutesTillNext, currentUser.hearts);
    Get.put(c);

    return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            LiquidCustomProgressIndicator(
              value: 1 - Get.find<HeartController>().minutesTillNext / 20,
              valueColor: AlwaysStoppedAnimation(Colors.redAccent),
              backgroundColor: Colors.white70,
              direction: Axis.vertical,
              shapePath: getHeartPath(Size(40, 40)),
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Text(
                  Get.find<HeartController>().hearts.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
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
  int minutesTillNext;
  int hearts;

  HeartController(this.minutesTillNext, this.hearts);

  incrementMinutesTillNext() {
    minutesTillNext++;
    update();
  }

  decrementMinutesTillNext() {
    minutesTillNext--;
    update();
  }
}

class MoneyIndicator extends StatelessWidget {
  final User currentUser;

  const MoneyIndicator({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PointsIndicator extends StatelessWidget {
  final User currentUser;

  const PointsIndicator({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
