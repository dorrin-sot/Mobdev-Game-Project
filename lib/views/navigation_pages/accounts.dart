import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/bar_chart_graph.dart';
import 'package:mobdev_game_project/models/bar_chart_model.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:mobdev_game_project/models/user_stats.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/navbar_related.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mobdev_game_project/views/common/laoding.dart';

class AccountsPageProfile extends StatelessWidget {
  //const AccountsPageProfile({Key? key}) : super(key: key);
  final List<BarChartModel> data = [];
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Subject.getAllFromDB(),
        builder: (context, snap) {
          if (!snap.hasData || (snap.data as List<Subject>).length == 0) {
            return LoadingSupportPage("اطلاعات اولیه");
          } else {
            List<Subject> allSubj = snap.data as List<Subject>;
            return FutureBuilder(
                future: UserStat.getUserStats(appController.currentUser!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      (snapshot.data as List<UserStat>).length == 0) {
                    return LoadingSupportPage("اطلاعات ثانویه");
                  } else {
                    List<UserStat> allStats = snapshot.data as List<UserStat>;
                    for (Subject subj in allSubj) {
                      int correctCount = 0;
                      int wrongOrTimeoutCount = 0;
                      for (UserStat stat in allStats) {
                        if (stat.question!.subject!.name == subj.name) {
                          if (stat.status == Status.correct)
                            correctCount++;
                          else
                            wrongOrTimeoutCount++;
                        }
                        double percent =
                            (correctCount + wrongOrTimeoutCount == 0)
                                ? 100
                                : 100 *
                                    (correctCount /
                                        (correctCount + wrongOrTimeoutCount));
                        var barColor = percent > 75
                            ? charts.ColorUtil.fromDartColor(Colors.green)
                            : percent > 50
                                ? charts.ColorUtil.fromDartColor(Colors.yellow)
                                : percent > 25
                                    ? charts.ColorUtil.fromDartColor(
                                        Colors.orange)
                                    : charts.ColorUtil.fromDartColor(
                                        Colors.red);
                        data.add(BarChartModel(
                            name: subj.name,
                            percent: percent.round(),
                            color: barColor));
                      }
                    }
                    return Center(
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(16.0),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(Get.width / 6),
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    final textStyle = TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    );
                                    final itemList = <ListTile>[
                                      ListTile(
                                        title: Text(
                                          'آپلود عکس پروفایل',
                                          textDirection: TextDirection.rtl,
                                          style: textStyle,
                                        ),
                                        leading: Icon(Icons.file_upload),
                                        onTap: () {
                                          // todo upload pfp
                                        },
                                      )
                                    ];
                                    // todo if current user has a pfp add options to edit or delete it
                                    return Container(
                                        child: ListView(
                                      children: itemList,
                                    ));
                                  },
                                ),
                                child: Container(
                                  width: Get.width / 3,
                                  height: Get.width / 3,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/userPhoto.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Get.width / 6 + 7.5)),
                                    border: Border.all(
                                      color: Colors.lightGreenAccent,
                                      width: 7.5,
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                appController.currentUser!.username!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontFamily: 'Lalezar',
                                    fontWeight: FontWeight.bold),
                              )),
                          BarChartGraph(data),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: Get.width / 4),
                            children: [
                              TextButton(
                                child: SizedBox(
                                  width: Get.width / 3,
                                  child: Text(
                                    'حذف اکانت',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'خطر!',
                                    titleStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 30),
                                      child: Text(
                                        'مطمینی میخوای اکانتتو حذف کنی؟\nدقت کن که این عمل قابل بازگشت نیست!!',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    textConfirm: 'حذف',
                                    onConfirm: () async {
                                      final currentUser =
                                          Get.find<AppController>()
                                              .currentUser!;
                                      await currentUser.delete();
                                      await currentUser.logout();
                                      Get.back();
                                      Get.find<NavBarController>()
                                          .setCurrent('/account/login');
                                    },
                                    textCancel: 'بیخیال',
                                  );
                                },
                              ),
                              ElevatedButton(
                                child: SizedBox(
                                  width: Get.width / 3,
                                  child: Text(
                                    'لاگ اوت',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.defaultDialog(
                                    title: '',
                                    titleStyle: TextStyle(fontSize: .01),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 30),
                                      child: Text(
                                        'مطمینی میخوای لاگ اوت کنی؟',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    textConfirm: 'لاگ اوت',
                                    onConfirm: () async {
                                      final currentUser =
                                          Get.find<AppController>()
                                              .currentUser!;
                                      await currentUser.logout();
                                      Get.back();
                                      Get.find<NavBarController>()
                                          .setCurrent('/account/login');
                                    },
                                    textCancel: 'بیخیال',
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                });
          }
        });
  }
}

class AccountsPageLogin extends StatelessWidget {
  // const AccountsPageLogin({Key? key}) : super(key: key);
  final AccountPageLoginController controller =
      Get.put(AccountPageLoginController());

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                  "ورود",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Lalezar', fontSize: 30),
                ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: controller.usernameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'نام کاربری',
                  ),
                )),
            Obx(() => Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  obscureText: controller.passwordVisible.value,
                  controller: controller.passwordController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'رمز عبور',
                    prefixIcon: InkWell(
                      child: Icon(
                        // Based on passwordVisible state choose the icon
                        (controller.passwordVisible.value)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onTap: () {
                        controller.togglePasswordVisiblity();
                      },
                    ),
                  ),
                ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      showLoaderDialog(context);
                      User(controller.usernameController.text,
                              controller.passwordController.text)
                          .login()
                          .then((response) {
                        if (response.success) {
                          Navigator.pop(context);
                          Get.find<NavBarController>().setCurrent('/home');
                          Get.snackbar(
                              "عملیات موفق", "با موفقیت وارد اکانتت شدی",
                              backgroundColor: Colors.blue,
                              colorText: Colors.white);
                        } else {
                          Navigator.pop(context);
                          String errorMessage = "";
                          switch (response.error!.code) {
                            case 100:
                              errorMessage = "ارتباط با سرور برقرار نشد!";
                              break;
                            case 101:
                              errorMessage = "نام کاربری یا رمزعبور اشتباه است";
                              break;
                            case 200:
                              errorMessage =
                                  "یادت رفت نام کاربریت رو وارد کنی!";
                              break;
                            case 201:
                              errorMessage = "یادت رفت رمزعبورت رو وارد کنی!";
                              break;
                            default:
                              response.toString();
                              break;
                          }
                          Get.defaultDialog(
                              title: "خطا",
                              titleStyle: TextStyle(color: Colors.red),
                              middleTextStyle: TextStyle(color: Colors.black),
                              middleText: errorMessage,
                              textCancel: 'باشه');
                        }
                        return response;
                      });
                    },
                    child: Text(
                      "ورود",
                      style: TextStyle(fontFamily: 'Traffic'),
                    ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: TextButton(
                    onPressed: () => Get.find<NavBarController>()
                        .setCurrent('/account/register'),
                    child: Text(
                      "اگه اکانت نداری برای ثبت نام کلیک کن",
                      style: TextStyle(fontFamily: 'Traffic'),
                    )))
          ],
        ),
      );

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "لطفا اندکی صبر بنمای...",
                    style:
                        TextStyle(fontFamily: 'Traffic', color: Colors.black),
                  ))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class AccountsPageRegister extends StatelessWidget {
  //const AccountsPageRegister({Key? key}) : super(key: key);
  final controller = AccountPageRegisterController();

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                  "ثبت نام",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Lalezar', fontSize: 30),
                ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: controller.usernameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'نام کاربری',
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: controller.emailController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ایمیل',
                  ),
                )),
            Obx(() => Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  obscureText: controller.passwordVisible.value,
                  controller: controller.passwordController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'رمز عبور',
                    prefixIcon: InkWell(
                      child: Icon(
                        // Based on passwordVisible state choose the icon
                        (controller.passwordVisible.value)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onTap: () {
                        controller.togglePasswordVisibility();
                      },
                    ),
                  ),
                ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      showLoaderDialog(context);
                      User.forParseRegister(controller.usernameController.text,
                              controller.passwordController.text,
                              emailAddress: controller.emailController.text)
                          .signUp()
                          .then((response) {
                        if (response.success) {
                          Navigator.pop(context);
                          Get.find<NavBarController>().setCurrent('/home');
                          Get.snackbar(
                              "عملیات موفق", "ثبت نامت با موفقیت انجام شد",
                              backgroundColor: Colors.blue,
                              colorText: Colors.white);
                        } else {
                          Navigator.pop(context);
                          String errorMessage = "";
                          switch (response.error!.code) {
                            case 100:
                              errorMessage = "ارتباط با سرور برقرار نشد!";
                              break;
                            case 125:
                              errorMessage = "فرمت ایمیلت اشتباهه!";
                              break;
                            case 202:
                              errorMessage = "این نام کاربری قبلا استفاده شده";
                              break;
                            case 203:
                              errorMessage = "این ایمیل قبلا استفاده شده";
                              break;
                            case 200:
                              errorMessage = "نام کاربری انتخاب نکردی";
                              break;
                            case 201:
                              errorMessage = "یادت رفت رمزعبور رو وارد کنی!";
                              break;
                            case 204:
                              errorMessage = "یادت رفت ایمیلت رو وارد کنی!";
                              break;
                            default:
                              response.toString();
                              break;
                          }
                          // dialog for register
                          Get.defaultDialog(
                              title: "خطا",
                              titleStyle: TextStyle(color: Colors.red),
                              middleText: errorMessage,
                              middleTextStyle: TextStyle(color: Colors.black),
                              textCancel: "باشه");
                        }
                        return response;
                      });
                      ;
                    },
                    child: Text(
                      "ثبت نام",
                      style: TextStyle(fontFamily: 'Traffic'),
                    ))),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: TextButton(
                    onPressed: () => Get.find<NavBarController>()
                        .setCurrent('/account/login'),
                    child: Text(
                      "قبلا اکانت ساختی؟ برای ورود کلیک کن",
                      style: TextStyle(fontFamily: 'Traffic'),
                    )))
          ],
        ),
      );

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "لطفا اندکی صبر بنمای...",
                    style:
                        TextStyle(fontFamily: 'Traffic', color: Colors.black),
                  ))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class AccountPageLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVisible = true.obs;

  void togglePasswordVisiblity() {
    passwordVisible.value = !(passwordVisible.value);
  }
}

class AccountPageRegisterController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordVisible = true.obs;

  void togglePasswordVisibility() {
    passwordVisible.value = !(passwordVisible.value);
  }
}
