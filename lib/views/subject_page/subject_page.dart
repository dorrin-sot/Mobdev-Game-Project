import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobdev_game_project/controllers/subject_page_controller.dart';
import 'package:mobdev_game_project/views/subject_page/subject.dart';
import 'package:mobdev_game_project/views/subject_page/laoding.dart';

class SubjectPage extends StatelessWidget {
  //todo fix fetching async data
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: GetX<SubjectPageController>(
                init: SubjectPageController(),
                builder: (controller) {
                  if ((controller.subjects() as List<String>).length == 0) {
                    return LoadingSupportPage();
                  } else {
                    return Column(children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                          ),
                          child: Center(
                            child: Text("لطفا یکیرو انتخاب کن"),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 9,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          children:
                              controller.subjects().map<Widget>((subject) {
                            return SubjectWidget(subject);
                          }).toList(),
                          // children: ccc.map((e) => Text(e)).toList(),
                        ),
                      ),
                    ]);
                  }
                })),
      ),
    );
  }
}
