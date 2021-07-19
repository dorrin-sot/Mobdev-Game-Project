import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/navbar_related.dart';
import 'package:mobdev_game_project/views/navigation_pages/accounts.dart';
import 'package:mobdev_game_project/views/navigation_pages/home.dart';
import 'package:mobdev_game_project/views/navigation_pages/settings.dart';
import 'package:mobdev_game_project/views/no_network_page.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          User(username!, password!),
      debug: true);

  final c = AppController();
  Get.put(c);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: GetMaterialApp(
          initialRoute: '/home',
          getPages: [
            GetPage(
                name: '/home',
                page: () => HomePage(),
                transition: Transition.noTransition),
            GetPage(
                name: '/settings',
                page: () => SettingsPage(),
                transition: Transition.noTransition),
            GetPage(
                name: '/account/profile',
                page: () => AccountsPageProfile(),
                transition: Transition.noTransition),
            GetPage(
                name: '/account/login',
                page: () => AccountsPageLogin(),
                transition: Transition.noTransition),
            GetPage(
                name: '/account/register',
                page: () => AccountsPageRegister(),
                transition: Transition.noTransition),
            GetPage(
                name: '/no-network',
                page: () => NoNetworkPage(),
                transition: Transition.rightToLeft),
          ],
          debugShowCheckedModeBanner: false,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppController extends GetxController {
  bool? isLoggedIn;
  User? currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await prefsOnInit();
  }

  prefsOnInit() async {
    print('AppController::prefsOnInit');
    final prefs = await SharedPreferences.getInstance();

    bool? isLoggedInPref = prefs.getBool('isLoggedIn');

    if (isLoggedInPref == null) {
      prefs.setBool('isLoggedIn', false);
    }

    prefs.reload();
    isLoggedInPref = prefs.getBool('isLoggedIn');
    String? curUserUNPref = prefs.getString('curUserUN');
    String? curUserPWPref = prefs.getString('curUserPW');

    if (isLoggedInPref!) {
      isLoggedIn = isLoggedInPref;
      currentUser = User.forParse(
        curUserUNPref!,
        curUserPWPref!,
      );
      update();
    }
  }

  prefsUpdate() async {
    print('AppController::prefsUpdate');
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isLoggedIn', isLoggedIn!);

    if (isLoggedIn!) {
      prefs.setString('curUserUN', currentUser!.username!);
      prefs.setString('curUserPW', currentUser!.password!);
    }
  }
}
