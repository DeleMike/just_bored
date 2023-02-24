import 'package:flutter/material.dart';

/// Personal Screen View
class PersonalScreen extends StatefulWidget {
  /// Personal Screen View
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Personal Home Screen'),
      ),
    );
  }
}
