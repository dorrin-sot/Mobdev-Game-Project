import 'package:flutter/material.dart';

class Subject extends StatelessWidget {
  //todo make this page beautiful
  //todo complete onPressed

  final String subjectName;
  const Subject(this.subjectName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(subjectName),
        onPressed: () {},
      ),
    );
  }
}
