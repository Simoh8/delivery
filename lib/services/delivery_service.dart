import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:delivery/services/session_manager.dart';

class DeliveryService {
  static const String _endpoint =
      'http://192.168.0.110:8000/api/method/ledgerctrl.ledgerctrl.api.delivery_note_events.close_delivery_note_with_otp';

  static Future<void> submitOtp({
    required BuildContext context,
    required String deliveryNoteName,
    required String otp,
  }) async {
    final session = await SessionManager.getSessionData();
    final sid = session['sid'];

    if (sid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please log in again.')),
      );
      return;
    }

    final url = Uri.parse(_endpoint);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'sid=$sid',
        },
        body: jsonEncode({
          'delivery_note_name': deliveryNoteName,
          'otp_input': otp,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        final errorMessage = result['message'] ??
            result['exc'] ??
            'Failed to close delivery note';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Delivery OTP error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
