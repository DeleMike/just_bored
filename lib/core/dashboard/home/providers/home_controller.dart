import 'dart:convert';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:just_bored/local/profile_prefs.dart';

import '../../../../network/http_client.dart' as client;
import 'package:just_bored/configs/constants.dart';
import '../../../../configs/debug_fns.dart';

/// controls & manages home screen
class HomeController with ChangeNotifier {
  /// controls & manages home screen
  HomeController();

  /// array of short tagline, generated by the ChatGPT model
  final _tagLines = [
    'The practice of mindfulness and meditation brings calmness and peace to the soul.',
    'Disconnecting from technology is the key to unlocking good mental health and peace of mind.',
    'The act of journaling can be a transformative tool for calming the mind and reflecting on thoughts.',
    'A positive environment is essential to promote good mental health and a peaceful state of mind.',
    '"We do not learn from experience, we learn from reflecting on experience." - John Dewey',
    '"Self-reflection is the school of wisdom." - Baltasar Gracian',
    '"Knowing yourself is the beginning of all wisdom." - Aristotle',
    '"The most important relationship you will ever have is the one with yourself." - Diane Von Furstenberg',
    'Setting boundaries and learning to say no are critical steps in reducing stress and achieving inner calm.',
    'Love is patient, kind, and always forgiving.',
    'Love isn\'t about finding someone perfect, it\'s about loving someone imperfectly.',
    'Love is not just romantic, it\'s also friendship, family, and community.',
    'Love is universal and knows no boundaries.',
    'Take care of your mind, it\'s the most important thing you\'ll ever own.',
    'A clear mind and a peaceful heart can overcome any obstacle.',
    'When you prioritize your mental health, everything else falls into place.',
    'Meditation is not an escape from reality, but a way to connect with it on a deeper level.',
    'Take a deep breath and let go of what no longer serves you.',
    'The power to find peace and calmness lies within you, so trust yourself.',
    'A peaceful mind is the foundation of a happy life.',
    'When you choose to focus on the positive, you create a more peaceful world.',
    'The journey to good mental health is a marathon, not a sprint. Pace yourself and enjoy the scenery.',
    'Love is the most powerful force in the world.',
    'Love is not just a feeling, it\'s a choice you make every day.',
    '"The unexamined life is not worth living." - Socrates',
    'Investing in self-care activities is a powerful way to promote good mental health and a peaceful state of mind.',
    'Exercise is not only great for the body, but also an effective way to reduce stress and promote mental wellbeing.',
    'Gratitude is the secret ingredient to inner peace and long-lasting happiness.',
    'Getting enough sleep is the foundation of good mental health and the key to unlocking a peaceful state of mind.',
    'Living in the present moment is the key to unlocking inner calm and reducing anxiety.',
    'Peace and calmness come from within, so take the time to nurture your mental health.',
    'The path to good mental health is paved with self-care and self-compassion.',
    '"True self-discovery begins where your comfort zone ends." - Adam Braun',
    '"Self-reflection is a humbling process. It\'s essential to find out why you think, say, and do certain things...then better yourself." - Sonya Teclai',
    '"Self-reflection is a mirror in which we can see beyond the surface of our thoughts and feelings." - Amit Ray',
    '"You have to do your own growing no matter how tall your grandfather was." - Abraham Lincoln'
  ];

  //Firebase realtime database instance
  FirebaseDatabase database = FirebaseDatabase.instance;

  String _tagLine = '';
  String get tagLine => _tagLine;

  /// fetch random taglines
  void fetchRandomTagLines() {
    // get a random number from 0 to length of array
    int number = math.Random().nextInt(_tagLines.length);
    _tagLine = _tagLines[number];
  }

  String _selectedMood = '';

  /// user selected mood
  String get selectedMood => _selectedMood;

  /// for mood change
  ///
  /// if the user selects an already selected mood, it clears away
  ///
  /// else it sets that selected mood as the current mood
  ///
  /// update the database with user current mood
  Future<void> selectMood(BuildContext context, String mood) async {
    if (_selectedMood == mood) {
      _selectedMood = 'normal';
    } else {
      _selectedMood = mood;
    }
    printOut('Update Mood = $_selectedMood', 'Home Controller');

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    printOut('UID = $uid', 'HomeController');

    // get current user id
    if (uid == null) {
      showToast('User updating mood cannot be empty');
      return;
    }

    // get timestamp
    final timestamp = DateTime.now();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      // data to send
      final data = {
        'mood': _selectedMood.toString().trim(),
        'time': timestamp.toString(),
      };
      final response = (await client.HttpClient.instance
          .post(resource: 'mood_logs/$uid.json', data: jsonEncode(data)) as http.Response);

      if (response.statusCode != 200) {
        showToast('Your mood could not be updated.\n You can try signing in again to update your mood.');
      } else {
        showToast(
          'Whatever it is you are feeling, remember to breathe in and out.'
          '\n You can look at the sun on your screen to help you breathe',
          wantsLongText: true,
          wantsCenterMsg: true,
        );
      }
    } catch (e, s) {
      //FATAL: Something went wrong in the code (Frontend or Backend)
      printOut('Error Message: $e, $s');
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    notifyListeners();
  }

  /// sets user reflection
  /// This will be allowed only twice a day, morning hours at 10am and evening hours at 8pm
  Future<void> setUserReflection({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, String> userReflection,
    required TextEditingController controller,
  }) async {
    // save time to local storage
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      formKey.currentState!.save();
      printOut(userReflection, 'Reflection');

      String? uid = FirebaseAuth.instance.currentUser?.uid;
      printOut('UID = $uid', 'HomeController');

      // get current user id
      if (uid == null) {
        showToast('User updating mood cannot be empty');
        return;
      }

      // get timestamp
      final timestamp = DateTime.now();
      final lastTimestamp = await ProfilePrefs().getLastReflectionTime();
      DateTime? lastTimeConverted;
      // parse the time
      if (lastTimestamp.isNotEmpty) {
        lastTimeConverted = DateTime.parse(lastTimestamp);
        printOut(lastTimeConverted.toString(), 'HomeController');
      }

      if (lastTimestamp.isEmpty) {
        // update asap
        await _updateFirebaseData(userReflection, timestamp, uid, controller);
      } else if (!(timestamp.isAfter(lastTimeConverted!.add(const Duration(hours: 8))))) {
        // check for our constraint
        // if time is not empty and last timestamp is not after 1 mins, deny update access
        // ignore: use_build_context_synchronously
        showToast(
          // context,
          'Please come back later to add a new reflection.'
          '\n You can only update your reflection after every 8 hours',
          wantsCenterMsg: true,
          wantsLongText: true,
        );
      } else {
        await _updateFirebaseData(userReflection, timestamp, uid, controller);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      notifyListeners();
    }
  }

  /// update the firebase database
  Future<void> _updateFirebaseData(
      Map<String, String> data, DateTime timestamp, String uid, TextEditingController controller) async {
    // get user reflection
    final reflection = data['reflection'];

    try {
      // data to send
      final data = {
        'reflection': reflection.toString().trim(),
        'time': timestamp.toString(),
      };
      printOut('Data = $data', 'HomeController');
      await ProfilePrefs().saveLastReflectionTime(timestamp.toString());

      final response = (await client.HttpClient.instance
          .post(resource: 'reflections/$uid.json', data: jsonEncode(data)) as http.Response);

      if (response.statusCode != 200) {
        showToast('Your reflection could not be saved.\n You can try signing in again to add a reflection.');
      } else {
        showToast(
          'Great!\nSelf-reflection definitely helps you grow',
          wantsLongText: true,
          wantsCenterMsg: true,
        );
        controller.text = '';
      }
    } catch (e, s) {
      //FATAL: Something went wrong in the code (Frontend or Backend)
      printOut('Error Message: $e, $s');
    }
  }

  /// reset all [HomeController] variable
  void reset() {
    _selectedMood = '';
    _tagLine = '';
  }
}
