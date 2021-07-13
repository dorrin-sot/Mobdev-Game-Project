import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobdev_game_project/controllers/subject_page_controller.dart';

class SubjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Page')),
      body: Container(
          child: GetX<SubjectPageController>(
              init: SubjectPageController(),
              builder: (controller) {
                if ((controller.subjects() as List<String>).length == 0) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    children: controller.subjects().map<Widget>((subject) {
                      return Text(subject);
                    }).toList(),
                    // children: ccc.map((e) => Text(e)).toList(),
                  );
                }
              })),
    );
  }
}
