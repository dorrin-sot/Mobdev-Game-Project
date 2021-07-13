import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:mobdev_game_project/main.dart';

class CustomBottomNavBar extends CurvedNavigationBar {
  CustomBottomNavBar() : super(items: []);

  static CurvedNavigationBar build() {
    final double iconSize = 30;
    int indexx = -1;
    final c = Get.find<AppController>();

    final navBarItems = <NavBarItem>[
      NavBarItem(
        index: ++indexx,
        child: Icon(
          Icons.settings,
          size: iconSize,
        ),
        pageDest: '/settings',
      ),
      NavBarItem(
        index: ++indexx,
        child: Icon(
          Icons.home,
          size: iconSize,
        ),
        pageDest: '/home',
      ),
      NavBarItem(
        index: ++indexx,
        child: Icon(
          Icons.account_circle,
          size: iconSize,
        ),
        pageDest: '/account/' +
            (c.isLoggedIn != null && c.isLoggedIn! ? 'login' : 'profile'),
      ),
    ];

    return CurvedNavigationBar(
      index: 1,
      items: navBarItems.map((e) => e.child).toList(),
      onTap: (index) => Get.toNamed(
        navBarItems.where((element) => element.index == index).first.pageDest!,
      ),
    );
  }
}

class NavBarItem {
  final int index;
  final Widget child;
  late String? pageDest;

  NavBarItem({required this.index, required this.child, this.pageDest});
}
