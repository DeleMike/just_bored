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

  static List<Widget> _navScreens = [];
  static List<BottomNavigationBarItem> _navBarItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _navScreens = const [
      HomeScreen(),
      AIHomeScreen(),
      PersonalScreen(),
    ];

    _navBarItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
      
      BottomNavigationBarItem(icon: Icon(Icons.assistant), label: 'You & AI'),
     
      BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Personal'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        currentIndex: _selectedIndex,
        unselectedItemColor: blueThreeVariantColor,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark ? kWhite : kPrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
