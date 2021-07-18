import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/views/subject_page/subject_page.dart';

import '../../appbar_related.dart';
import '../../navbar_related.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: ElevatedButton(
              child: Text("کلیک بنمای"),
              onPressed: () => Get.to(SubjectPage()),
            ),
          ),
        ),
      );
}
