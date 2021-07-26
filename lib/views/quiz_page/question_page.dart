import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/utils/utils.dart';
import 'package:mobdev_game_project/views/common/laoding.dart';
import 'package:mobdev_game_project/views/quiz_page/answer_widget.dart';
import 'package:mobdev_game_project/views/quiz_page/clock_widget.dart';

class QuestionPage extends StatelessWidget {
  final Subject subject = Get.arguments['subject'];
  final QuestionPageController questionPageController =
      Get.put(QuestionPageController());
  LinearGradient _gradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomCenter,
    colors: [
      Colors.teal,
      Colors.indigo,
      Colors.deepPurple,
      Colors.purple,
    ],
  );

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Scaffold(
      body: FutureBuilder(
        future: questionPageController.fetchQuestions(subject),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return LoadingSupportPage("سوالات");
          } else if ((snapshot.data as List<Question>).length == 0) {
            return noResult(_themeData);
          } else {
            return SafeArea(
              child: Container(
                // color: Colors.deepPurpleAccent.withAlpha(-100),
                decoration: BoxDecoration(gradient: _gradient),
                child: Center(
                  child: Obx(() {
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.transparent,

                            width: double.infinity,
                            height: double.infinity,
                            // color: Colors.purple,
                            child: Center(
                              child: Text(
                                questionPageController
                                    .questions![questionPageController.index]
                                    .question!,
                                style: _themeData.textTheme.headline2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: AnswersListView(),
                            )),
                        Expanded(flex: 4, child: Clock()),
                      ],
                    );
                  }),
                ),
              ),
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

  Widget noResult(ThemeData _themeData) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: _linearGradient),

      child: Center(
        child: Container(

          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: _themeData.primaryColor,
              blurRadius: 30,
              spreadRadius: 15,
            ),
          ]),
          child: Text(
            "متاسفانه سوالی برای نمایش وجود ندارد",
            textAlign: TextAlign.center,
            style: _themeData.textTheme.headline2!,
          ),
        ),
      ),
    );
  }

  LinearGradient _linearGradient = LinearGradient(
    colors: [
      Colors.yellow,
      Colors.red,
      Colors.indigo,
      Colors.teal,
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.1,
      0.4,
      0.6,
      0.9,
    ],
  );
}
