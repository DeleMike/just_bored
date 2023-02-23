import 'package:flutter/material.dart';
import 'package:just_bored/configs/constants.dart';

import '../../../../widgets/jb_app_bar.dart';

/// Home screen view
class HomeScreen extends StatefulWidget {
  /// Home screen view
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: const JBAppbar(
          headerText: kAppName,
          needsABackButton: false,
          color: kPrimaryColor,
          iconColor: kWhite,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: kScreenHeight(context) * 0.8,
                width: kScreenWidth(context),
                //constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: const FlutterLogo(
                  size: 300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: kScreenHeight(context) * 0.4,
                width: kScreenWidth(context),
                // constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(color: kCanvasColor),
                child: const FlutterLogo(
                  size: 200,
                ),
              ),
            ),
          ],
        ));
  }
}
