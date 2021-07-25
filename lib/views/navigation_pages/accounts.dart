import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/navbar_related.dart';
import 'package:mobdev_game_project/views/navigation_pages/home.dart';

class AccountsPageProfile extends StatelessWidget {
  //const AccountsPageProfile({Key? key}) : super(key: key);

  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/userPhoto.png',
                  width: Get.width / 3,
                  height: Get.width / 3,
                )),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  appController.currentUser!.username!,
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      );
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
                child: GoogleAuthButton(
                  onPressed: () {
                    // todo your implementation
                  },
                  isLoading: false,
                  style: const AuthButtonStyle(
                    buttonType: AuthButtonType.secondary,
                    iconType: AuthIconType.outlined,
                  ),
                )),
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
                    onPressed: () {
                      Get.back();
                    },
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
