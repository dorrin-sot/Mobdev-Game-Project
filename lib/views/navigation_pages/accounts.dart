import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:mobdev_game_project/views/navigation_pages/home.dart';
import 'package:auth_buttons/auth_buttons.dart';

class AccountsPageProfile extends StatelessWidget {
  const AccountsPageProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: const Text('AccountsPageProfile'),
      );
}

class AccountsPageLogin extends StatelessWidget {
  // const AccountsPageLogin({Key? key}) : super(key: key);
  final AccountPageLoginController controller =
      Get.put(AccountPageLoginController());

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Text("ورود"),
            TextField(
              controller: controller.usernameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'نام کاربری',
              ),
            ),
            Obx(() => TextField(
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
                      onTap:() {controller.togglePasswordVisiblity();},
                    ),
                  ),
                )),
            TextButton(
                onPressed: () {
                  User.forParse(controller.usernameController.text,
                          controller.passwordController.text)
                      .login()
                      .then((response) {
                    if (response.success) {
                      Get.off(HomePage());
                      Get.snackbar("عملیات موفق", "با موفقیت وارد اکانتت شدی",
                          backgroundColor: Colors.black,
                          colorText: Colors.white);
                    } else {
                      String errorMessage = "";
                      switch (response.error!.code) {
                        case 100:
                          {
                            errorMessage = "ارتباط با سرور برقرار نشد!";
                          }
                          break;
                        case 101:
                          {
                            errorMessage = "نام کاربری یا رمزعبور اشتباه است";
                          }
                          break;
                        case 200:
                          {
                            errorMessage = "یادت رفت نام کاربریت رو وارد کنی!";
                          }
                          break;
                        case 201:
                          {
                            errorMessage = "یادت رفت رمزعبورت رو وارد کنی!";
                          }
                          break;
                        default:
                          {
                            response.toString();
                          }
                          break;
                      }
                      Get.defaultDialog(
                          title: "خطا",
                          titleStyle: TextStyle(color: Colors.red),
                          content: Text(
                            errorMessage,
                          ),
                          textConfirm: "باشه");
                    }
                    return response;
                  });
                },
                child: Text("ورود")),
            GoogleAuthButton(
              onPressed: () {
                // your implementation
              },
              isLoading: false,
              style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                iconType: AuthIconType.outlined,
              ),
            ),
            TextButton(
                onPressed: () {
                  Get.to(AccountsPageRegister());
                },
                child: Text("اگه اکانت نداری برای ثبت نام کلیک کن"))
          ],
        ),
      );
}

class AccountsPageRegister extends StatelessWidget {
  //const AccountsPageRegister({Key? key}) : super(key: key);
  final controller = AccountPageRegisterController();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Text("ثبت نام"),
            TextField(
              controller: controller.usernameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'نام کاربری',
              ),
            ),
            TextField(
              controller: controller.emailController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ایمیل',
              ),
            ),
            Obx(() => TextField(
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
                  onTap:() {controller.togglePasswordVisiblity();},
                ),
              ),
            )),
            TextButton(
                onPressed: () {
                  User.forParse(controller.usernameController.text,
                          controller.passwordController.text,
                          emailAddress: controller.emailController.text)
                      .signUp()
                      .then((response) {
                    if (response.success) {
                      Get.off(HomePage());
                      Get.snackbar("عملیات موفق", "ثبت نامت با موفقیت انجام شد",
                          backgroundColor: Colors.black,
                          colorText: Colors.white);
                    } else {
                      String errorMessage = "";
                      switch (response.error!.code) {
                        case 100:
                          {
                            errorMessage = "ارتباط با سرور برقرار نشد!";
                          }
                          break;
                        case 202:
                          {
                            errorMessage = "این نام کاربری قبلا استفاده شده";
                          }
                          break;
                        case 203:
                          {
                            errorMessage = "این ایمیل قبلا استفاده شده";
                          }
                          break;
                        case 200:
                          {
                            errorMessage = "نام کاربری انتخاب نکردی";
                          }
                          break;
                        case 201:
                          {
                            errorMessage = "یادت رفت رمزعبور رو وارد کنی!";
                          }
                          break;
                        case 204:
                          {
                            errorMessage = "یادت رفت ایمیلت رو وارد کنی!";
                          }
                          break;
                        default:
                          {
                            response.toString();
                          }
                          break;
                      }
                      Get.defaultDialog(
                          title: "خطا",
                          titleStyle: TextStyle(color: Colors.red),
                          content: Text(
                            errorMessage,
                          ),
                          textConfirm: "باشه");
                    }
                    return response;
                  });
                  ;
                },
                child: Text("ثبت نام")),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("قبلا اکانت ساختی؟ برای ورود کلیک کن"))
          ],
        ),
      );
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

  void togglePasswordVisiblity() {
    passwordVisible.value = !(passwordVisible.value);
  }
}
