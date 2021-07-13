import 'package:flutter/material.dart';

class LoadingSupportPage extends StatelessWidget {
  const LoadingSupportPage({Key? key}) : super(key: key);
  //todo make this page beautiful
  //todo make an animation here
  //todo make an appbar to return if fetching data takes so long

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "در حال چکش کاری موضوعات!",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10,),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
