import 'dart:core';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class User extends ParseUser implements ParseCloneable {
  static const String _keyTableName = '_User';

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

  int? correctQCount;
  int? incorrectQCount;
  int? timeoutQCount;
  int? hearts;
  int? money;
  int? points;
  DateTime? heartsLastUpdateTime;

  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  static const HEARTS_MAX = 20;
  static final HEART_ADD_INTERVAL = 15; // in minutes

  User(String? username, String? password,
      {String? emailAddress, String? sessionToken})
      : super(username, password, emailAddress, sessionToken: sessionToken);

  factory User.forParseRegister(String username, String password,
          {String? emailAddress,
          int hearts = HEARTS_MAX,
          int correctQCount = 0,
          int incorrectQCount = 0,
          int timeoutQCount = 0,
          int money = 100,
          int points = 5,
          DateTime? heartsLastUpdateTime}) =>
      User(username, password, emailAddress: emailAddress)
        ..set(keyCorrectQCount, correctQCount)
        ..set(keyIncorrectQCount, incorrectQCount)
        ..set(keyTimeoutQCount, timeoutQCount)
        ..set(keyHearts, hearts)
        ..set(keyMoney, money)
        ..set(keyPoints, points)
        ..set(keyHeartsLastUpdateTime, heartsLastUpdateTime ?? DateTime.now());

  factory User.fromJsonn(Map<String, dynamic> json) =>
      User(json[keyUsername], '',
          emailAddress: json[keyEmail], sessionToken: json['sessionToken'])
        ..correctQCount = json[keyCorrectQCount]
        ..incorrectQCount = json[keyIncorrectQCount]
        ..timeoutQCount = json[keyTimeoutQCount]
        ..hearts = json[keyHearts]
        ..money = json[keyMoney]
        ..points = json[keyPoints]
        ..heartsLastUpdateTime = DateTime.parse(
            (json[keyHeartsLastUpdateTime] as Map<String, dynamic>)['iso'])
        ..objectId = json['objectId'];

  @override
  Future<ParseResponse> login({bool doNotSendInstallationID = false}) async {
    int? errorCode;
    if (username!.isEmpty) errorCode = 200;
    if (password!.isEmpty) errorCode = 201;
    if (errorCode != null)
      return ParseResponse(error: ParseError(code: errorCode));

    return await super
        .login(doNotSendInstallationID: doNotSendInstallationID)
        .then((response) async {
      if (response.success) {
        final c = Get.find<AppController>();
        c.isLoggedIn.value = true;
        await c.saveUserInPrefs(this);
        c.update();
      }
      return response;
    });
  }

  static Future<bool> loginGoogle(
      {String? username, String? password, String? email}) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    final account = await _googleSignIn.signIn();
    if (account == null) return false;
    final authentication = await account.authentication;

    print('display name: ${account.displayName!}');
    print('email: ${account.email}');
    return ParseUser.loginWith(
      'google',
      google(_googleSignIn.currentUser!.id, authentication.accessToken!,
          authentication.idToken!),
      username: 'User${(await count()).toInt()}',
      password: '',
    ).then((response) async {
      if (!response.success)
        await logoutGoogle();
      else {
        final c = Get.find<AppController>();
        c.isLoggedIn.value = true;
        c.saveUserInPrefs(response.result);
      }
      return response.success;
    });
  }

  @override
  Future<ParseResponse> logout({bool deleteLocalUserData = true}) async {
    return await super
        .logout(deleteLocalUserData: deleteLocalUserData)
        .then((response) {
      if (response.success) {
        final c = Get.find<AppController>();
        c.isLoggedIn.value = false;
        c.saveUserInPrefs(null);
      }
      return response;
    });
  }

  static logoutGoogle() async => GoogleSignIn().disconnect();

  @override
  Future<ParseResponse> signUp(
      {bool allowWithoutEmail = false,
      bool doNotSendInstallationID = false}) async {
    int? errorCode;
    if (username!.isEmpty) errorCode = 200;
    if (password!.isEmpty) errorCode = 201;
    if (!allowWithoutEmail && emailAddress!.isEmpty) errorCode = 204;
    if (errorCode != null)
      return ParseResponse(error: ParseError(code: errorCode));

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

  static Future<bool> signUpGoogle() async {
    return loginGoogle(
      username: 'User${count()}',
      password: '',
    );
  }

  static Future<bool> userExists(String username) async {
    final q = QueryBuilder<ParseUser>(User(username, ''))
      ..whereEqualTo(keyUsername, username);
    var response = await q.find();
    return response.isNotEmpty;
  }

  addQuestion(Question question) => getRelation(keyAllQuestions).add(question);

  double get timeDoneFraction {
    if (hearts == HEARTS_MAX) return 1;
    final res =
        DateTime.now().difference(heartsLastUpdateTime!).inSeconds.toDouble() /
            (HEART_ADD_INTERVAL * 60).toDouble();
    return res;
  }

  double get minutesTillNext => (1 - timeDoneFraction) * HEART_ADD_INTERVAL;

  updateHearts() async {
    if (hearts! >= HEARTS_MAX) return;

    final dHeart = timeDoneFraction.floor();
    setIncrement(keyHearts, dHeart);
    heartsLastUpdateTime = heartsLastUpdateTime!
        .add(Duration(minutes: dHeart * HEART_ADD_INTERVAL))
        .at0secs();

    save().then((value) => Get.find<HeartController>().update());
  }

  useHeart() async {
    assert(hearts! > 0);

    if (hearts == HEARTS_MAX) {
      heartsLastUpdateTime = DateTime.now().at0secs();
    }

    setDecrement(keyHearts, 1);
    await save();
    Get.find<HeartController>().update();
  }

  static Future<int> count() async {
    return (QueryBuilder<ParseObject>(ParseUser.forQuery())
          ..keysToReturn(['objectId']))
        .count()
        .then((response) => response.result);
  }

  @override
  String toString() {
    // return jsonEncode(this);
    return '${super.toString()}    User{correctQCount: $correctQCount, incorrectQCount: $incorrectQCount, timeoutQCount: $timeoutQCount, hearts: $hearts, money: $money, points: $points, heartsLastUpdateTime: $heartsLastUpdateTime}';
  }
}

extension DateTimeClone on DateTime {
  DateTime at0secs() {
    return this.subtract(Duration(seconds: second));
  }
}
