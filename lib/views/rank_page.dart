import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/models/user.dart';

import 'common/laoding.dart';

class Pair {
  Color _a;
  Color _b;

  Pair(this._a, this._b);

  Color get b => _b;

  set b(Color value) {
    _b = value;
  }

  Color get a => _a;

  set a(Color value) {
    _a = value;
  }
}

class RankPageController extends GetxController {
  Rx<Random> _random = Random().obs;
  RxList<List<Color>> list = [<Color>[]].obs;

  Rx<Random> get random => _random;
  List colors = <Pair>[
    Pair(Colors.red, Colors.redAccent),
    Pair(Colors.green, Colors.greenAccent),
    Pair(Colors.blue, Colors.blueAccent),
    Pair(Colors.brown, Colors.brown.shade300),
    Pair(Colors.purple, Colors.purpleAccent),
    Pair(Colors.yellow, Colors.yellowAccent),
  ];

  set random(Rx<Random> value) {
    _random = value;
  }

  @override
  void onInit() {
    list.removeAt(0);
    for(int i =0;i<100;i++){
      list.add(getColors());

    }
    print("my list: ${list.toString()}");
    super.onInit();
  }

  List<Color> getColors() {
    int num = _random.value.nextInt(6);
    return <Color>[
      colors[num].a,
      colors[num].b,
    ];
  }
}

class RankPage extends StatelessWidget {
  RankPage({Key? key}) : super(key: key);

  RankPageController _rankPageController = Get.put(RankPageController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchRanks(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData || (snapshot.data as List<User>).length == 0) {
            return LoadingSupportPage("رنک ها");
          } else {
            List<User> users = snapshot.data;
            print(users.toString());
            return SafeArea(
              child: Container(
                color: Colors.white70,
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      // return Text("salam" ,style: TextStyle(color: Colors.black),);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 7.5, left: 15, right: 15, top: 7.5),
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _rankPageController.list[index],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset:
                                  Offset(0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              tileColor: Colors.white70,
                              title: Text(
                                users[index].username!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Lalezar",
                                    fontSize: 50),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "امتیاز",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Lalezar",
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "امتیاز",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Lalezar",
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              leading: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                              isThreeLine: true,
                            ),
                          );
                        }),
                      );
                    }),
              ),
            );
          }
        },
      ),
    );
  }

  // ListView.builder(itemCount: (snapshot.data as List<User>).length,itemBuilder: (context , index){
  //
  // },)
  Future<List<User>> fetchRanks() {
    return Future.delayed(Duration(seconds: 2), () {
      return [
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),

        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),

        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),

        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),

        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
        User("y1", "p1"),
      ];
    });
  }
}
