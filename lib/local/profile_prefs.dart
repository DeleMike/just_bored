import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:just_bored/configs/debug_fns.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages user profile preferences
class ProfilePrefs extends ChangeNotifier {
  /// Manages user profile preferences
  ProfilePrefs();

  static const userProfileKey = 'userProfile';
  static const reflectionTimeKey = 'reflectionTimeKey';

  final Map<String, dynamic> _userProfile = {
    'display_name': '',
    'uid': '',
    'email': '',
  };

  Map<String, dynamic> get userProfile => _userProfile;

  String _reflectionTime = '';

  /// last reflection time
  String get reflectionTime => _reflectionTime;

  /// save user details
  Future<void> saveUser(User? user) async {
    if (user == null) return;
    //final prefs = await SharedPreferences.getInstance();
    // Map<String, dynamic> encodedUser = {
    //   'display_name': user.displayName,
    //   'uid': user.uid,
    //   'email': user.email,
    // };
    _userProfile['display_name'] = user.displayName;
    _userProfile['uid'] = user.uid;
    _userProfile['email'] = user.email;

    printOut('Saved user: ${jsonEncode(_userProfile)}', 'ProfilePrefs');
    //notifyListeners();

    //prefs.setString(userProfileKey, jsonEncode(encodedUser));
  }

  /// Fetch user details
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String encodedUser = prefs.getString(userProfileKey) ?? '{}';
    Map<String, dynamic> result = jsonDecode(encodedUser);
    _userProfile['display_name'] = result['display_name'];
    _userProfile['uid'] = result['uid'];
    _userProfile['email'] = result['email'];

    printOut(_userProfile.toString(), 'ProfilePrefs');
    //notifyListeners();
  }

  /// Save onboarding view status to `true`
  ///  this is because the user has seen this screen one time and has no need to view it again
  Future<void> saveLastReflectionTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(reflectionTimeKey, time);
  }

  ///  get onboarding viewing status
  Future<String> getLastReflectionTime() async {
    final prefs = await SharedPreferences.getInstance();
    _reflectionTime =
        prefs.getString(reflectionTimeKey) ?? ''; // return false if user has never viewed onboarding

    printOut('reflectionTime = $_reflectionTime', 'Profile');
    return _reflectionTime;
  }

  String getUserId() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return userId;
  }
}
