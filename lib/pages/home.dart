import 'package:flutter/material.dart';

import '../appbar_related.dart';
import '../navbar_related.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar.build(),
        bottomNavigationBar: CustomBottomNavBar.build(),
        backgroundColor: Colors.white,
        body: Center(child: const Text('HomePage')),
      );
}
