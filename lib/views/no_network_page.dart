import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NoNetworkPage extends StatelessWidget {
  const NoNetworkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.fill,
        child: Stack(
          children: [
            // fixme fix this shit ffs
            Image(
              image: AssetImage('images/no_net_image.webp'),
              fit: BoxFit.fitHeight,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (!(await NoNetworkPage.isNoNetwork())) Get.back();
                },
                child: const Text('حالا دوباره سعیتو بکن'),
              ),
            )
          ],
        ),
      );

  static Future<bool> isNoNetwork() async =>
      (await Connectivity().checkConnectivity()) == ConnectivityResult.none;
}
