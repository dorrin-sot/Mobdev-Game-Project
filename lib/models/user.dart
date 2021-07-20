import 'dart:core';

import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class User extends ParseUser {
  static const String _keyTableName = 'User';

  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyEmail = 'email';
  static const String keyAllQuestions = 'allQuestions';
  static const String keyCorrectQCount = 'correctQCount';
  static const String keyIncorrectQCount = 'incorrectQCount';
  static const String keyTimeoutQCount = 'timeoutQCount';
  static const String keyHearts = 'hearts';
  static const String keyHeartsLastUpdateTime = 'heartsLastUpdateTime';
  static const String keyMoney = 'money';
  static const String keyPoints = 'points';

  static const HEARTS_MAX = 20;
  static final HEART_ADD_INTERVAL = 15; // in minutes

  User(String username, String password, {String? emailAddress})
      : super(username, password, emailAddress);

  factory User.forParse(String username, String password,
          {String? emailAddress,
          int hearts = HEARTS_MAX,
          int money = 100,
          int points = 5,
          DateTime? heartsLastUpdateTime}) =>
      User(username, password, emailAddress: emailAddress)
        ..hearts = hearts
        ..money = money
        ..points = points
        ..heartsLastUpdateTime = heartsLastUpdateTime ?? DateTime.now();

  @override
  Future<ParseResponse> login({bool doNotSendInstallationID = false}) async {
    return await super
        .login(doNotSendInstallationID: doNotSendInstallationID)
        .then((response) {
      if (response.success) {
        final c = Get.find<AppController>();
        c.isLoggedIn.value = true;
        c.currentUser = this;
        c.prefsUpdate();
        c.update();
      }
      return response;
    });
  }

  loginGoogle({required String email}) async {
    // fixme fix after ui done
    // final GoogleSignIn _googleSignIn = GoogleSignIn(
    //     scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
    // final account = (await _googleSignIn.signIn())!;
    // final authentication = await account.authentication;
    //
    // await ParseUser.loginWith(
    //         'google',
    //         google(_googleSignIn.currentUser!.id, authentication.accessToken!,
    //             authentication.idToken!))
    //     .then((response) {
    //   final c = Get.find<AppController>();
    //   c.isLoggedIn = true;
    //   c.currentUser = this;
    //   c.update();
    // });
  }

  @override
  Future<ParseResponse> logout({bool deleteLocalUserData = true}) async {
    return await super
        .logout(deleteLocalUserData: deleteLocalUserData)
        .then((response) {
      if (response.success) {
        final c = Get.find<AppController>();
        c.isLoggedIn.value = false;
        c.currentUser = null;
        c.prefsUpdate();
        c.update();
      }
      return response;
    });
  }

  logoutGoogle() async {
    // fixme add after ui done
  }

  @override
  Future<ParseResponse> signUp(
      {bool allowWithoutEmail = false,
      bool doNotSendInstallationID = false}) async {
    return await super
        .signUp(
            allowWithoutEmail: allowWithoutEmail,
            doNotSendInstallationID: doNotSendInstallationID)
        .then((response) {
      if (response.success) {
        login(); // also login after signup
      }
      return response;
    });
  }

  signUpGoogle() async {
    // fixme add after ui done
  }

  static Future<bool> userExists(String username) async {
    final q = QueryBuilder<ParseUser>(User(username, ''))
      ..whereEqualTo(keyUsername, username);
    var response = await q.find();
    return response.isNotEmpty;
  }

  int get hearts => get<int>(keyHearts)!;

  set hearts(int value) => set<int>(keyHearts, value);

  int get money => get<int>(keyMoney)!;

  set money(int value) => set<int>(keyMoney, value);

  int get points => get<int>(keyPoints)!;

  set points(int value) => set<int>(keyPoints, value);

  ParseRelation<Question> get allQuestions => getRelation(keyAllQuestions);

  set allQuestions(ParseRelation<Question> value) =>
      set<ParseRelation<Question>>(keyAllQuestions, value);

  addQuestion(Question question) => getRelation(keyAllQuestions).add(question);

  DateTime get heartsLastUpdateTime => get<DateTime>(keyHeartsLastUpdateTime)!;

  set heartsLastUpdateTime(DateTime value) =>
      set<DateTime>(keyHeartsLastUpdateTime, value);

  double get timeDoneFraction {
    if (hearts == HEARTS_MAX) return 1;
    final res =
        DateTime.now().difference(heartsLastUpdateTime).inSeconds.toDouble() /
            (HEART_ADD_INTERVAL * 60).toDouble();
    return res;
  }

  double get minutesTillNext => (1 - timeDoneFraction) * HEART_ADD_INTERVAL;

  updateHearts() async {
    if (hearts >= HEARTS_MAX) return;

    final dHeart = timeDoneFraction.floor();
    setIncrement(keyHearts, dHeart);
    heartsLastUpdateTime = heartsLastUpdateTime
        .add(Duration(minutes: dHeart * HEART_ADD_INTERVAL))
        .at0secs();

    save().then((value) => Get.find<HeartController>().update());
  }

  useHeart() async {
    assert(hearts > 0);

    if (hearts == HEARTS_MAX) {
      heartsLastUpdateTime = DateTime.now().at0secs();
    }

    setDecrement(keyHearts, 1);
    await save();
    Get.find<HeartController>().update();
  }
}

extension DateTimeClone on DateTime {
  DateTime at0secs() {
    return this.subtract(Duration(seconds: second));
  }
}
