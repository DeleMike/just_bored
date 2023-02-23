import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import '../../configs/constants.dart';
import '../dashboard/home/screens/home.dart';
import '../dashboard/ai/screens/ai_home.dart';
import '../dashboard/personal/screens/personal_screen.dart';

/// root navigation screen
class NavScreen extends StatefulWidget {
  /// root navigation screen
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static List<Widget> _navScreens = [];
  static List<CurvedNavigationBarItem> _navBarItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _navScreens = const [
      HomeScreen(),
      AIHomeScreen(),
      PersonalScreen(),
    ];

    _navBarItems = const [
      CurvedNavigationBarItem(
        child: Icon(Icons.home_filled, color: kLightPrimaryColor),
        label: 'Home',
      ),
      CurvedNavigationBarItem(
        child: Icon(Icons.assistant, color: kLightPrimaryColor),
        label: 'AI & You',
      ),
      CurvedNavigationBarItem(
        child: Icon(Icons.person_2, color: kLightPrimaryColor),
        label: 'Personal',
      ),
    ];
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _navScreens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _navBarItems,
        backgroundColor: kTransparent,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.ease,
        iconPadding: kPaddingM,
        height: kBottomNavigationBarHeight + 10,
        buttonBackgroundColor: kAccentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
