import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingSupportPage extends StatelessWidget {
  final String whatToShow;

  LoadingSupportPage(this.whatToShow); //todo make this page beautiful
  //todo make an animation here

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "در حال چکس کاری" + whatToShow,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
