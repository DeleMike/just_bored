import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_controller.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final authReader = context.read<AuthController>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User signed in with $email'),
            ElevatedButton.icon(
              onPressed: () async {
                await authReader.logout(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
