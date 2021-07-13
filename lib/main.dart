import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/appbar_related.dart';
import 'package:mobdev_game_project/models/app_controller.dart';
import 'package:mobdev_game_project/views/subject_page/subject_page.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'models/question.dart';
import 'models/subject.dart';
import 'models/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final keyApplicationId = dotenv.env['keyApplicationId']!;
  final keyParseServerUrl = dotenv.env['keyParseServerUrl']!;
  final keyClientKey = dotenv.env['keyParseClientKey']!;

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      registeredSubClassMap: <String, ParseObject Function()>{
        'Question': () => Question(),
        'Subject': () => Subject()
      },
      parseUserConstructor: (username, password, emailAddress,
              {client, debug, sessionToken}) =>
          User(username, password),
      debug: true);

  Get.put(AppController());

  runApp(GetMaterialApp(home: GameApp()));
}

class GameApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // fixme remove below when login page is added
    final c = Get.find<AppController>();
    User("test", "test").login();
    c.update();
    // end fixme remove below when login page is added


    return Scaffold(
      appBar: CustomAppbar.build(),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: ElevatedButton(
            child: Text("کلیک بنمای"),
            onPressed: () => Get.to(SubjectPage()),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CustomBottomNavBar extends CurvedNavigationBar {
  CustomBottomNavBar()
      : super(items: [
          Icon(Icons.eighteen_mp)
          // todo
        ]);
}
