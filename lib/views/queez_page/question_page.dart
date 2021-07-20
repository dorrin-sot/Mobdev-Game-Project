import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:mobdev_game_project/views/queez_page/answer_widget.dart';
import 'package:mobdev_game_project/views/queez_page/clock_widget.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class QuestionPage extends StatelessWidget {
  final String subject;
  final QuestionPageController questionPageController =
      Get.put(QuestionPageController());

  QuestionPage(this.subject);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
      ),
      body: FutureBuilder(
        future: questionPageController.fetchQuestions(subject),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData ||
              (snapshot.data as List<dynamic>).length == 0) {
            return CircularProgressIndicator();
          } else {
            return Center(
              child: Obx(() {
                return Column(
                  children: [
                    Text(
                        "question ${questionPageController.index.toString()} from controller: " +
                            questionPageController
                                .questions![questionPageController.index]
                                .question!),
                    AnswersListView(),
                    Clock(),
                  ],
                );
              }),
            );
          }
        },
      ),
    );
  }

  ListView AnswersListView() {
    questionPageController.correctAnswer = questionPageController
            .questions![questionPageController.index].correctAns! -
        1;
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        4,
        (index) => AnswerWidget(
          questionPageController
              .questions![questionPageController.index].answers![index],
          index,
        ),
      ),
    );
  }
}
