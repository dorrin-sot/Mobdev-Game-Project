import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:mobdev_game_project/models/user.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/navbar_related.dart';

class AccountsPageProfile extends StatelessWidget {
  const AccountsPageProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: Center(child: const Text('AccountsPageProfile')),
      );
}

class AccountsPageLogin extends StatelessWidget {
  // const AccountsPageLogin({Key? key}) : super(key: key);

  final AccountPageLoginController controller =
      Get.put(AccountPageLoginController());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: Center(
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
            TextField(
              obscureText: true,
              controller: controller.passwordController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'رمز عبور',
              ),
            ),
            TextButton(
                onPressed: () {
                  User(controller.usernameController.text,
                          controller.passwordController.text)
                      .login();
                },
                child: Text("ورود")),
            TextButton(
                onPressed: () {
                  Get.to(AccountsPageRegister());
                },
                child: Text("اگه اکانت نداری برای ثبت نام کلیک کن"))
          ],
        )),
      );
}

class AccountsPageRegister extends StatelessWidget {
  //const AccountsPageRegister({Key? key}) : super(key: key);
  final controller = AccountPageRegisterController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: Center(
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
            TextField(
              obscureText: true,
              controller: controller.passwordController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'رمز عبور',
              ),
            ),
            TextButton(
                onPressed: () {
                  User(controller.usernameController.text,
                          controller.passwordController.text,emailAddress:controller.emailController.text)
                      .signUp();
                },
                child: Text("ثبت نام")),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("قبلا اکانت ساختی؟ برای ورود کلیک کن"))
          ],
        )),
      );
}

class AccountPageLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
}

class AccountPageRegisterController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
}
