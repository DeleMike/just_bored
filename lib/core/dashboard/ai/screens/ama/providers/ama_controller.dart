import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/openai.dart';

import '../../../../../../local/profile_prefs.dart';
import '../../../../../../configs/debug_fns.dart';
import '../models/ama.dart';

/// controller for the AMA Session
class AmaController with ChangeNotifier {
  /// controller for the AMA Session
  AmaController();

  // user chats
  List<Ama> _chats = [];

  /// user chats
  List<Ama> get chats => _chats;

  bool _isLoading = false;

  /// show if the model is processing data
  bool get isLoading => _isLoading;

  /// this will send the message to the ChatGPT model and get a response for the user
  Future<void> sendMessage({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, String> messageData,
    required TextEditingController controller,
    required OpenAI? openAiInstance,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      _isLoading = true;
      notifyListeners();

      formKey.currentState!.save();
      final message = messageData['message'];
      printOut(message, 'AmaController');
      // printOut('OpenAI Instance = $openAiInstance', 'AmaController');
      String? uid = ProfilePrefs().getUserId();

      chats.add(Ama.fromjson({
        'id': uid,
        'message': message,
        'is_user': true,
      }));

      // reply the user based from their message
      String reply = await _sendReply(message!, openAiInstance);

      // add to chats array
      chats.add(
        Ama.fromjson({
          'id': 'just-bored-ai',
          'message': reply,
          'is_user': false,
        }),
      );

      controller.text = '';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// initialise AI engine for task
  OpenAI? initAIEngine() {
    OpenAI? openAI;

    // init the API key
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    OpenAI.apiKey = apiKey!;
    if (kDebugMode) {
      OpenAI.showLogs = true;
    }
    openAI = OpenAI.instance;

    return openAI;
  }

  /// initialise a chat
  Future<void> initChat(OpenAI? openAI) async {
    String msg = 'Hi, I wanna talk with you?';
    String? uid = ProfilePrefs().getUserId();

    chats.add(Ama.fromjson({
      'id': uid,
      'message': msg,
      'is_user': true,
    }));
    _isLoading = true;

    String reply = await _sendReply(msg, openAI);

    // add to chats array
    chats.add(
      Ama.fromjson({
        'id': 'just-bored-ai',
        'message': reply,
        'is_user': false,
      }),
    );
    _isLoading = false;
    notifyListeners();
  }

  /// reply user based on message sent
  Future<String> _sendReply(String userMsg, OpenAI? openAI) async {
    final OpenAIChatCompletionModel chatCompletion = await openAI!.chat.create(
      model: "gpt-3.5-turbo",
      temperature: 0.89,
      maxTokens: 1000,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(content: userMsg, role: "user"),
      ],
    );

    String reply = chatCompletion.choices.last.message.content.trim();

    return reply;
  }

  // reset variables state
  void reset() {
    _chats = [];
    _isLoading = false;
  }
}
