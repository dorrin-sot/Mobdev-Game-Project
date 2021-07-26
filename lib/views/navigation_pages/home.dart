import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/views/rank_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  AppController _appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/animated_lamp.gif',
                  width: Get.width / 3,
                  height: Get.width / 3,
                )),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "کوییزستان",
                  style: TextStyle(
                      fontFamily: 'Lalezar',
                      fontSize: 40,
                      foreground: Paint()
                        ..shader = ui.Gradient.linear(
                          const Offset(0, 350),
                          const Offset(450, 350),
                          <Color>[
                            Colors.red,
                            Colors.yellow,
                          ],
                        )),
                )),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: ElevatedButton(
                  child: Text(
                    "بازی جدید",
                    style: TextStyle(fontFamily: 'Traffic'),
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: ElevatedButton(
                  child: Text(
                    "رنک خفنا رو ببین",
                    style: TextStyle(fontFamily: 'Traffic'),
                  ),
                  onPressed: () =>Get.to(RankPage()),
                ),
              ),
            ),
          ],
        ),
      );

  void onPressed() {
    if (_appController.isLoggedIn.value) {
      Get.toNamed('/subjects');
      return;
    } else {
      Get.snackbar(
        "امکان ورود برای شما محیا نیست",
        "اول باید ثبت نام کنی",
        icon: Icon(Icons.person, color: Colors.black),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
