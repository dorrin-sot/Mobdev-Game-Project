import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:mobdev_game_project/main.dart';
import 'package:mobdev_game_project/views/navigation_pages/accounts.dart';
import 'package:mobdev_game_project/views/navigation_pages/home.dart';
import 'package:mobdev_game_project/views/navigation_pages/settings.dart';
import 'package:mobdev_game_project/views/subject_page/subject_page.dart';

class CustomBottomNavBar extends CurvedNavigationBar {
  CustomBottomNavBar({
    required Key key,
    required int index,
    required List<Widget> items,
    required void Function(int) onTap,
  }) : super(key: key, index: index, items: items, onTap: onTap);

  factory CustomBottomNavBar.build() {
    final c = Get.put(NavBarController());

    return CustomBottomNavBar(
      index: 1,
      key: c.navbarStateKey,
      items: NavBarItem.allItems.map((e) => e.iconWidget!).toList(),
      onTap: (index) {
        c.setCurrent(
          NavBarController.getNavBarItem(index).pageDest,
          setIndexToo: false,
        );
      },
    );
  }
}

class NavBarController extends GetxController {
  var currentPage = getNavBarItem(1).body.obs;

  late GlobalKey<CurvedNavigationBarState> navbarStateKey = GlobalKey();

  static NavBarItem getNavBarItem(int index) =>
      NavBarItem.allItems.firstWhere((element) => element.index == index);

  setCurrent(String currentPageName, {bool setIndexToo = true}) {
    print('NavBarController::setCurrent');
    final navbarItem = NavBarItem.allItems.firstWhere(
      (element) => element.pageDest == currentPageName,
      orElse: () {
        Widget? body;
        switch (currentPageName) {
          case '/account/register':
            body = AccountsPageRegister();
            break;
          default:
            body = null; // shouldnt happen
        }
        return NavBarItem(
          pageDest: currentPageName,
          body: body!,
        );
      },
    );
    if (setIndexToo && navbarItem.index != null) {
      navbarStateKey.currentState!.setPage(navbarItem.index!);
    }
    currentPage.value = navbarItem.body;
    update();
  }
}

class NavBarItem {
  final int? index;
  final Widget? iconWidget;
  final Widget body;
  late String pageDest;

  static List<NavBarItem> get allItems {
    int indexx = -1;
    final double iconSize = 30;
    final c = Get.find<AppController>();
    return <NavBarItem>[
      NavBarItem(
        index: ++indexx,
        iconWidget: Icon(
          Icons.settings,
          size: iconSize,
        ),
        pageDest: '/settings',
        body: SettingsPage(),
      ),
      NavBarItem(
        index: ++indexx,
        iconWidget: Icon(
          Icons.home,
          size: iconSize,
        ),
        pageDest: '/home',
        body: HomePage(),
      ),
      NavBarItem(
          index: ++indexx,
          iconWidget: Icon(
            Icons.account_circle,
            size: iconSize,
          ),
          pageDest: '/account/' + (c.isLoggedIn.isFalse ? 'login' : 'profile'),
          body: (c.isLoggedIn.isFalse
              ? AccountsPageLogin()
              : AccountsPageProfile())),
    ];
  }

  NavBarItem({
    this.index,
    this.iconWidget,
    required this.pageDest,
    required this.body,
  });

  @override
  String toString() {
    return 'NavBarItem{index: $index, iconWidget: $iconWidget, body: $body, pageDest: $pageDest}';
  }
}
