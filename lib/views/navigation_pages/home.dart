import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  style: TextStyle(fontFamily: 'Lalezar', fontSize: 40,foreground: Paint()
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
                  onPressed: () => Get.toNamed('/subjects'),
                ),
              ),
            )
          ],
        ),
      );
}
