import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingSupportPage extends StatelessWidget {
  final String whatToShow;

  LoadingSupportPage(this.whatToShow);
  //todo make an animation here

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: _linearGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: _themeData.primaryColor, blurRadius: 30 ,spreadRadius: 15)]),
              child: Text(
                 " در حال چکش کاری "+ whatToShow ,
                textAlign: TextAlign.center,
                style: _themeData.textTheme.headline2!
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(height: 70,width:70,child: CircularProgressIndicator(backgroundColor: Colors.yellowAccent,color: Colors.black, strokeWidth: 15,))
          ],
        ),
      ),
    );
  }
  LinearGradient _linearGradient =LinearGradient(
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
