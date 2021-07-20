import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/views/queez_page/question_page.dart';

class SubjectWidget extends StatelessWidget {
  //todo make this page beautiful
  //todo complete onPressed

  final Subject subject;

  const SubjectWidget(this.subject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(subject.name!),
        onPressed: () {
          Get.toNamed("/question_page", arguments: {'subject': subject});
        },
      ),
    );
  }
}
