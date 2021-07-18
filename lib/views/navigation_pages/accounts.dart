import 'package:flutter/material.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
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
  const AccountsPageLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar.build(),
    bottomNavigationBar: CustomBottomNavBar.build(),
    backgroundColor: Colors.white,
    body: Center(child: const Text('AccountsPageLogin')),
  );
}

class AccountsPageRegister extends StatelessWidget {
  const AccountsPageRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar.build(),
    bottomNavigationBar: CustomBottomNavBar.build(),
    backgroundColor: Colors.white,
    body: Center(child: const Text('AccountsPageRegister')),
  );
}
