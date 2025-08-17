import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery/models/user_info.dart';

class SessionManager {
  static const _keySid = 'sid';
  static const _keyApiKey = 'api_key';
  static const _keyApiSecret = 'api_secret';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyUserInfo = 'user_info';

  /// Save login session credentials
  static Future<void> saveSession({
    required String sid,
    required String apiKey,
    required String apiSecret,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySid, sid);
    await prefs.setString(_keyApiKey, apiKey);
    await prefs.setString(_keyApiSecret, apiSecret);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
  }

  /// Save user profile to local storage
  static Future<void> saveUserInfo(UserInfo user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUserInfo, userJson);
  }

  /// Retrieve user profile from local cache
  static Future<UserInfo?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUserInfo);
    if (userJson == null) return null;
    final userMap = jsonDecode(userJson);
    return UserInfo.fromJson(userMap);
  }

  /// Check if the session exists
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySid) != null;
  }

  /// Check if user profile exists in cache
  static Future<bool> hasUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserInfo);
  }

  /// Get stored session data
  static Future<Map<String, String?>> getSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'sid': prefs.getString(_keySid),
      'api_key': prefs.getString(_keyApiKey),
      'api_secret': prefs.getString(_keyApiSecret),
      'username': prefs.getString(_keyUsername),
      'email': prefs.getString(_keyEmail),
    };
  }

  /// Clear session and user profile info (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySid);
    await prefs.remove(_keyApiKey);
    await prefs.remove(_keyApiSecret);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyUserInfo);
  }

  /// Clear only the user profile (not the session)
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserInfo);
  }
}
