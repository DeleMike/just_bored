import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_bored/configs/constants.dart';

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
    required OpenAI? openAiInstance,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      final message = messageData['message'];
      printOut(message, 'AmaController');
      printOut('OpenAI Instance = $openAiInstance', 'AmaController');

      // reply the user based from their message
     // String reply = await _sendReply(message!, openAiInstance);
      _sendReply('', openAiInstance);

      // String? uid = ProfilePrefs().getUserId();

      // // add to chats array
      // chats.addAll([
      //   Ama.fromjson({
      //     'id': uid,
      //     'message': message,
      //     'is_user': true,
      //   }),
      //   Ama.fromjson({
      //     'id': 'just-bored-ai',
      //     'message': 'I am not implemented yet.\nWith time we should be communicating soon! 😉',
      //     'is_user': false,
      //   }),
      // ]);

      // controller.text = '';
      notifyListeners();
    }
  }

  // ignore: unused_element
  Future<void> _modelDataList(OpenAI openAi, String token) async {
    final models = await openAi.listModel();
    _printAIData(models.data, true);
  }

  // ignore: unused_element
  Future<void> _engineList(OpenAI openAi, String token) async {
    final engines = await openAi.listEngine();
    _printAIData(engines.data, false);
  }

  void _printAIData(List data, bool isModel) {
    kTranslateModelV2;
    for (var singleData in data) {
      if (isModel) {
        printOut('AI Model =  ${singleData.toJson()}');
      } else {
        printOut('AI Engine = ${singleData.toJson()}');
      }
    }
  }

  /// initialise AI engine for task
  OpenAI? initAIEngine() {
    OpenAI? openAI;
    // open ai key
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null) {
      showToast('Open AI Api key is not valid');
    } else {
      openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(sendTimeout: 100000, receiveTimeout: 100000, connectTimeout: 100000),
        isLogger: true,
      );

      // await _modelDataList(openAI, apiKey);
      // await _engineList(openAI, apiKey);
    }
    printOut('OpenAI = $openAI');

    return openAI;
  }

  /// reply user based on message sent
  void _sendReply(String userMsg, OpenAI? openAI) async {
    final request = CompleteText(
      prompt: 'What is human life expectancy in the United States?',
      model: kTranslateModelV3,
      maxTokens: 2000,
    );

    // await openAI.onCompleteText(request: request);

    openAI!.onCompleteStream(request: request).listen((response) => printOut(response)).onError((err) {
      printOut("$err");
    });
    //return '';
  }

  // reset variables state
  void reset() {
    _chats = [
      Ama(id: '1', message: 'Hello', isUser: true),
      Ama(id: '2', message: 'Hi there! How may I help you today?', isUser: false),
    ];
  }
}
