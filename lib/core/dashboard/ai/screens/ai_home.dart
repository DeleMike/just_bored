import 'package:flutter/material.dart';

/// AI Home Screen
class AIHomeScreen extends StatefulWidget {
  /// AI Home Screen
  const AIHomeScreen({super.key});

  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AI Home Screen'),
      ),
    );
  }
}
