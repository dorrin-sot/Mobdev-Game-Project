import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingSupportPage extends StatelessWidget {
  final String whatToShow;

  LoadingSupportPage(this.whatToShow); //todo make this page beautiful
  //todo make an animation here

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Center(
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
            height: 30,
          ),
          Container(height: 70,width:70,child: CircularProgressIndicator(backgroundColor: Colors.yellowAccent,color: Colors.black, strokeWidth: 15,))
        ],
      ),
    );
  }
}
