import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/models/subject.dart';

class SubjectWidget extends StatelessWidget {
  //todo make this page beautiful

  final Subject subject;

  const SubjectWidget(this.subject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Theme.of(context);
    return ElevatedButton(
      child: Text(subject.name!, style: _themeData.textTheme.headline3!),
      style: _themeData.elevatedButtonTheme.style!.copyWith(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.resolveWith((states) => setColor(states, _themeData))
      ),
      onPressed: () {
        Get.toNamed("/question_page", arguments: {'subject': subject});
      },
    );
  }
  Color setColor(Set<MaterialState> states , ThemeData themeData){
    Set<MaterialState> materialState ={
      MaterialState.focused,
      MaterialState.pressed,
      MaterialState.hovered,
    };
    if(states.any(materialState.contains)){
      return Colors.yellow;
    }
    return Colors.transparent;

  }
}
