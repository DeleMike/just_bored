import 'package:dart_openai/src/instance/openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:just_bored/configs/constants.dart';
import 'package:just_bored/configs/debug_fns.dart';

import '../../../../../../local/profile_prefs.dart';
import '../models/imagery.dart';

/// Controls all AI imagery functions
class ImageryController with ChangeNotifier {
  /// Controls all AI imagery functions
  ImageryController();

  // user chats
  List<Imagery> _promptsAndImages = [];

  /// user prompts and images generated
  List<Imagery> get promptsAndImages => _promptsAndImages;

  bool _isLoading = false;

  /// show if the model is processing data
  bool get isLoading => _isLoading;

  /// this will send a prompt to the DALL-E model and get a image url response for the user
  Future<void> sendPrompt({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, String> promptData,
    required TextEditingController controller,
    OpenAI? openAiInstance,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      _isLoading = true;
      notifyListeners();

      formKey.currentState!.save();
      final prompt = promptData['prompt'];
      printOut('Prompt = $prompt');
      String? uid = ProfilePrefs().getUserId();

      _promptsAndImages.add(Imagery.fromjson({
        'id': uid,
        'prompt': prompt,
        'image_url': '',
        'is_user': true,
      }));

      // reply the user based from their message
      await Future.delayed(const Duration(seconds: 2));
      // String reply = await _sendReply(message!, openAiInstance);

      _promptsAndImages.add(Imagery.fromjson({
        'id': uid,
        'prompt': '',
        'image_url': kNetworkImage,
        'is_user': false,
      }));

      controller.text = '';
      _isLoading = false;
      notifyListeners();
    }
  }

  // reset variables state
  void reset() {
    _promptsAndImages = [];
    _isLoading = false;
  }
}
