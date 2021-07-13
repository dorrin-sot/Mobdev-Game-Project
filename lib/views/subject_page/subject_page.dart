import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/views/subject_page/subject.dart';
import 'package:mobdev_game_project/views/subject_page/laoding.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class SubjectPage extends StatelessWidget {
  Future<List<dynamic>?> getSubjects() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Subject'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!;
    } else {
      print("we fucked up");
      return [];
    }
  }

  //todo fix fetching async data
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: FutureBuilder(
                future: getSubjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      (snapshot.data as List<dynamic>).length == 0) {
                    return LoadingSupportPage();
                  } else {
                    return Column(children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text("لطفا یکیرو انتخاب کن"),
                                ),
                                Wrap(children: [
                                  Icon(Icons.favorite),
                                  Text("24")
                                ]),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 9,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          children: (snapshot.data as List<dynamic>)
                              .map<Widget>((subject) {
                            return SubjectWidget(subject.get<String>('name'));
                          }).toList(),
                          // children: ccc.map((e) => Text(e)).toList(),
                        ),
                      ),
                    ]);
                  }
                })),
      ),
    );
  }
}
