import 'package:get/get.dart';
import 'package:mobdev_game_project/models/app_controller.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class User extends ParseUser {
  static const String _keyTableName = 'User';

  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyEmail = 'email';
  static const String keyCorrectQs = 'correctQs';
  static const String keyIncorrectQs = 'incorrectQs';
  static const String keyTimeoutQs = 'timeoutQs';
  static const String keyHearts = 'hearts';
  static const String keyHeartsLastUpdateTime = 'heartsLastUpdateTime';
  static const String keyMoney = 'money';
  static const String keyPoints = 'points';

  static final HEARTS_MAX = 20;
  static final HEART_ADD_INTERVAL = 15; // in minutes

  User(String? username, String? password, {String? emailAddress})
      : super(username, password, emailAddress);

  @override
  Future<ParseResponse> login({bool doNotSendInstallationID = false}) async {
    return await super
        .login(doNotSendInstallationID: doNotSendInstallationID)
        .then((response) {
      if (response.success) {
        final c = Get.find<AppController>();
        c.isLoggedIn = true;
        c.update();
      }
      return response;
    });
  }

  int get hearts => get<int>(keyHearts)!;

  set hearts(int value) => set<int>(keyHearts, value);

  int get money => get<int>(keyMoney)!;

  set money(int value) => set<int>(keyMoney, value);

  int get points => get<int>(keyPoints)!;

  set points(int value) => set<int>(keyPoints, value);

  List<Question> get correctQs => get<List<Question>>(keyCorrectQs)!;

  set correctQs(List<Question> value) =>
      set<List<Question>>(keyCorrectQs, value);

  List<Question> get incorrectQs => get<List<Question>>(keyIncorrectQs)!;

  set incorrectQs(List<Question> value) =>
      set<List<Question>>(keyIncorrectQs, value);

  List<Question> get timeoutQs => get<List<Question>>(keyTimeoutQs)!;

  set timeoutQs(List<Question> value) =>
      set<List<Question>>(keyTimeoutQs, value);

  DateTime get heartsLastUpdateTime => get<DateTime>(keyHeartsLastUpdateTime)!;

  set heartsLastUpdateTime(DateTime value) =>
      set<DateTime>(keyHeartsLastUpdateTime, value);

  int get minutesTillNext {
    if (hearts == HEARTS_MAX) return 0;
    return DateTime.now()
        .difference(
            heartsLastUpdateTime.add(Duration(minutes: HEART_ADD_INTERVAL)))
        .inMinutes;
  }

  addHeart() {
    assert(hearts != HEARTS_MAX);

    if (minutesTillNext >= HEART_ADD_INTERVAL) {
      final minutesPassed =
          DateTime.now().difference(heartsLastUpdateTime).inMinutes;

      final numOfAddedHearts = (minutesPassed / HEART_ADD_INTERVAL) as int;

      // hearts become full after adding
      if (hearts + numOfAddedHearts >= HEARTS_MAX) {
        hearts = HEARTS_MAX;
        // set last update to now
        heartsLastUpdateTime = DateTime.now();
      }
      // hearts incomplete even after adding
      else {
        setIncrement(keyHearts, numOfAddedHearts);
        // set last update to remainder from last interval
        heartsLastUpdateTime = DateTime.now()
            .subtract(Duration(minutes: minutesPassed % HEART_ADD_INTERVAL));
      }
    }
    save();
  }

  useHeart() {
    // fixme needs testing after using of hearts get added
    assert(hearts > 0);

    setDecrement(keyHearts, 1);

    if (hearts == 20) {
      heartsLastUpdateTime = DateTime.now(); // start countdown from now
    } else {
      final minutesPassed =
          heartsLastUpdateTime.difference(DateTime.now()).inMinutes;
      // set last update to remainder from last interval
      heartsLastUpdateTime = DateTime.now()
          .subtract(Duration(minutes: minutesPassed % HEART_ADD_INTERVAL));
    }
    save();
  }
}
