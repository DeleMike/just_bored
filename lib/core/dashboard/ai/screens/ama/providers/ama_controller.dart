import 'package:flutter/material.dart';

import '../../../../../../local/profile_prefs.dart';
import '../../../../../../configs/debug_fns.dart';
import '../models/ama.dart';

/// controller for the AMA Session
class AmaController with ChangeNotifier {
  /// controller for the AMA Session
  AmaController();

  // user chats
  List<Ama> _chats = [
    Ama(id: '1', message: 'Hello', isUser: true),
    Ama(id: '2', message: 'Hi there! How may I help you today?', isUser: false),
  ];

  List<Ama> get chats => _chats;

  /// this will send the message to the ChatGPT model and get a response for the user
  Future<void> sendMessage({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, String> messageData,
    required TextEditingController controller,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      final message = messageData['message'];
      printOut(message, 'AmaController');

      String? uid = ProfilePrefs().getUserId();

      // add to chats array
      chats.addAll([
        Ama.fromjson({
          'id': uid,
          'message': message,
          'is_user': true,
        }),
        Ama.fromjson({
          'id': 'just-bored-ai',
          'message': 'I am not implemented yet.\nWith time we should be communicating soon! 😉',
          'is_user': false,
        }),
      ]);

      controller.text = '';
      notifyListeners();
    }
    
  }

  // reset variables state
  void reset() {
    _chats = [
      Ama(id: '1', message: 'Hello', isUser: true),
      Ama(id: '2', message: 'Hi there! How may I help you today?', isUser: false),
    ];
  }
}
