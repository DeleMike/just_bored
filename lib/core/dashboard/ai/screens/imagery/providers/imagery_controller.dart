import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:just_bored/data/image_download_sharer.dart';
import 'package:just_bored/data/storage_bucket.dart';
import 'package:just_bored/local/profile_prefs.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../network/http_client.dart' as client;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_bored/configs/constants.dart';

import '../../../../../../configs/debug_fns.dart';
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

  int _groupIdCounter = 1;

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

      printOut('groupIdCounter = $_groupIdCounter');

      _promptsAndImages.add(Imagery.fromjson({
        'id': uid,
        'prompt': prompt,
        'image_url': '',
        'is_user': true,
        'group_id': _groupIdCounter,
        'is_uploaded': false,
      }));

      // reply the user based from their message
      // await Future.delayed(const Duration(seconds: 2));
      String? generatedImageUrl = await _getImageUrlResponse(prompt!, openAiInstance);

      //kNetworkImage
      _promptsAndImages.add(Imagery.fromjson({
        'id': uid,
        'prompt': '',
        'image_url': generatedImageUrl,
        'is_user': false,
        'group_id': _groupIdCounter,
        'is_uploaded': false,
      }));

      controller.text = '';
      _isLoading = false;
      notifyListeners();
    }
    ++_groupIdCounter;
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

  /// reply user based on message sent
  Future<String> _getImageUrlResponse(String prompt, OpenAI? openAI) async {
    String url = '';

    try {
      final OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: prompt,
        n: 1,
        size: OpenAIImageSize.size1024,
        responseFormat: OpenAIResponseFormat.url,
      );
      url = image.data.last.url;
    } on SocketException catch (e) {
      showToast('Connection timeOut: $e');
    } on RequestFailedException catch (e, s) {
      showToast(
        'Your prompt may contain text that is not allowed by DALL-E system.',
        wantsCenterMsg: true,
        wantsLongText: true,
      );
      printOut('An error occured = $e, $s', 'ImageryController');
    }

    printOut('Image url = $url');
    return url;
  }

  Future<void> saveFavouritePicture(BuildContext context, int groupId, String replyUrl) async {
    // get the prompt that generated the image
    Imagery imagery =
        _promptsAndImages.firstWhere((element) => element.groupId == groupId && element.prompt.isNotEmpty);

    printOut('Prompt = ${imagery.prompt}');
    printOut('replyUrl = $replyUrl');

    if (!imagery.isUploaded) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // download the image and save it to firebase buckets
      String firebaseStorageBucketDownloadUrl =
          await StorageBucketUploader.instance.uploadFavoritePicture(replyUrl, imagery.prompt);

      showToast('Picture uploaded!');
      printOut('DownloadURL = $firebaseStorageBucketDownloadUrl');

      // update the imagery model with groupId = [groupId] to uploaded
      for (var imagery in _promptsAndImages) {
        if (imagery.groupId == groupId) {
          imagery.isUploaded = true;
        }
      }

      String? uid = FirebaseAuth.instance.currentUser?.uid;
      printOut('UID = $uid', 'HomeController');
      try {
        final data = {
          'prompt': imagery.prompt,
          'image_url': firebaseStorageBucketDownloadUrl,
        };

        printOut('Data = $data', 'HomeController');

        final response = (await client.HttpClient.instance
            .post(resource: 'favourites/$uid.json', data: jsonEncode(data)) as http.Response);

        if (response.statusCode != 200) {
          showToast('Your image data properties could not be uploaded but your image has been saved!');
        } else {
          if (context.mounted) {
            showASnackbar(
              context,
              'Image Saved for you 💖',
            );
          }
        }
      } catch (e, s) {
        //FATAL: Something went wrong in the code (Frontend or Backend)
        printOut('Error Message: $e, $s');
      }
      navigatorKey.currentState!.pop();
      notifyListeners();
    } else {
      showASnackbar(context, 'This picture is already saved 😊');
    }
  }

  /// share AI generated picture to socials
  Future<void> shareToSocial(BuildContext context, int groupId, String imageUrl) async {
    final time = DateTime.now();
    // get the prompt that generated the image
    Imagery imagery =
        _promptsAndImages.firstWhere((element) => element.groupId == groupId && element.prompt.isNotEmpty);
    String imgFileName =
        '${imagery.prompt.toLowerCase().trim().replaceAll(' ', '_')}_${time.toString().trim().replaceAll(' ', '_').replaceAll('-', '_')}.png';

    // init class
    final sharer = ImageDownloaderSharer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // download the image
    File? file = await sharer.downloadImage(imageUrl, imgFileName);

    // share file
    try {
      // ignore: unused_local_variable
      final shareResult = await Share.shareXFiles(
        [
          XFile(
            file!.path,
            mimeType: 'image/png',
          )
        ],
        text: imagery.prompt,
      );
      // printOut('Share Result Raw data = ${shareResult.raw.toString()}', 'ImageController');
      // printOut('Share Result status index = ${shareResult.status.index}', 'ImageControler');
      // printOut('Share Result status name = ${shareResult.status.name}', 'ImageControler');
      showToast('Image Shared!');
    } catch (e, s) {
      printOut('Error while sharing file: $e, $s');
    }
    navigatorKey.currentState!.pop();
    notifyListeners();
  }

  // reset variables state
  void reset() {
    _promptsAndImages = [];
    _isLoading = false;
    _groupIdCounter = 1;
  }
}
