import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:delivery/services/session_manager.dart';
import 'package:delivery/constants/app_constants.dart';

class ApiService {
  static const int _timeoutSeconds = 10; // ⏳ configurable timeout
  static const int _maxRetries = 2;     // 🔄 retry a couple of times

  /// Generic GET
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final sid = await _getSidOrThrow();
    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

    final response = await _withRetry(() {
      return http.get(url, headers: _headers(sid))
          .timeout(const Duration(seconds: _timeoutSeconds));
    });

    return _handleResponse(response);
  }

  /// Raw POST (no sid cookie)
  static Future<Map<String, dynamic>> rawPost(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

    final response = await _withRetry(() {
      return http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: _timeoutSeconds));
    });

    return _handleResponse(response);
  }

  /// Authenticated POST
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final sid = await _getSidOrThrow();
    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

    final response = await _withRetry(() {
      return http.post(
        url,
        headers: _headers(sid),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: _timeoutSeconds));
    });

    return _handleResponse(response);
  }

  // --- Helpers --- //

  static Future<String> _getSidOrThrow() async {
    final session = await SessionManager.getSessionData();
    final sid = session['sid'];
    if (sid == null) {
      throw Exception('No session found. User not logged in.');
    }
    return sid;
  }

  static Map<String, String> _headers(String sid) => {
    'Content-Type': 'application/json',
    'Cookie': 'sid=$sid',
  };

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      if (response.statusCode == 403 ||
          (data['exception']?.contains('DisabledUserError') ?? false)) {
        SessionManager.logout();
        throw Exception('Your account has been disabled. You have been logged out.');
      }
      throw Exception(
        'API Error: ${response.statusCode} - ${data['message'] ?? response.body}',
      );
    }
  }

  /// retry wrapper
  static Future<http.Response> _withRetry(
      Future<http.Response> Function() requestFn) async {
    int attempt = 0;
    while (true) {
      try {
        return await requestFn();
      } on TimeoutException {
        attempt++;
        if (attempt > _maxRetries) rethrow;
        await Future.delayed(const Duration(milliseconds: 500)); // backoff
      } on http.ClientException catch (_) {
        attempt++;
        if (attempt > _maxRetries) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }
}
