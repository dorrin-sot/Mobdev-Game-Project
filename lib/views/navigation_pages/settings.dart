import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  //const SettingsPage({Key? key}) : super(key: key);
  final controller = SettingPageController();

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        children: [
          Text("تنظیمات"),
          Row(children: [
            Obx(() => Slider(
                  value: controller.songValue.value,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (double value) {
                    controller.changeSongValue(value);
                  },
                )),
            Text(
              "موسیقی",
              style: TextStyle(color: Colors.black),
            )
          ])
        ],
      ));
}

class SettingPageController extends GetxController {
  final songValue = 50.0.obs;

  void changeSongValue(double value) {
    songValue.value = value;
  }
}
