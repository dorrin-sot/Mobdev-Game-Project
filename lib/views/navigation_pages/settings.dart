import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class SettingsPage extends StatelessWidget {
  //const SettingsPage({Key? key}) : super(key: key);
  final controller = SettingPageController();
  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("تنظیمات", style: TextStyle(color: Colors.black,fontFamily: 'Traffic')),
          ),
          Row(children: [
            Obx(() => Padding(
                padding: EdgeInsets.all(16.0),
                child: Slider(
                  value: controller.songValue.value,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (double value) {
                    controller.changeSongValue(value);
                  },onChangeEnd:(double value)=> controller.saveSongValue(value),
                ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "موسیقی",
                  style: TextStyle(color: Colors.black,fontFamily: 'Lalezar',fontSize: 20),
                ))
          ])
        ],
      ));
}

class SettingPageController extends GetxController {
  final songValue = 80.0.obs;
  final c = Get.find<AppController>();

  @override
  Future<void> onInit() async{
    super.onInit();
    await setFirstVolume();
  }
  setFirstVolume() async {
    songValue.value=c.volume;
    print("set volume");
  }
  void changeSongValue(double value) {
    songValue.value=value;
    c.setMusicVolume(value/100);

  }
  void saveSongValue(double value) {
    c.volume=value/100;
    c.prefsUpdate();
    c.update();

  }
}
