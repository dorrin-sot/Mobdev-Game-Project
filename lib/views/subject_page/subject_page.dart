import 'package:flutter/material.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/utils/utils.dart';
import 'package:mobdev_game_project/views/subject_page/subject_widget.dart';
import 'package:mobdev_game_project/views/common/laoding.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SubjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepOrange],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.repeated),
            // color: themeData.primaryColor
          ),
          child: FutureBuilder(
              future: Subject.getAllFromDB(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    (snapshot.data as List<Subject>).length == 0) {
                  return LoadingSupportPage("موضوعات");
                } else {
                  return Column(children: [
                    Expanded(flex: 2, child: chooseText(themeData)),
                    Expanded(
                      flex: 8,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        children: (snapshot.data as List<Subject>)
                            .map<Widget>((subject) {
                          return SubjectWidget(subject);
                        }).toList(),
                      ),
                    ),
                  ]);
                }
              }),
        ),
      ),
    );
  }

  Widget chooseText(ThemeData themeData) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeData.primaryColor.withOpacity(.50),
            spreadRadius: 0.01,
            blurRadius: 100,
          )
        ],
      ),
      child: SizedBox(
        height: 50,
        child: Center(
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FadeAnimatedText("لطفا یک موضوع انتخاب کن",
                  textStyle: themeData.textTheme.headline2),
            ],
          ),
        ),
      ),
    );
  }
}
