import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery/models/order.dart';
import 'package:delivery/services/session_manager.dart';
import 'package:delivery/constants/app_constants.dart';

class OrderService {
  static const String _cacheKey = 'cached_assigned_orders';

  static Future<List<OrderItemModel>> getAssignedOrders() async {
    final session = await SessionManager.getSessionData();
    final sid = session['sid'];

    if (sid == null) {
      throw Exception('No session found. User not logged in.');
    }

    // ✅ Use AppConstants for base URL + endpoint
    final url = Uri.parse(
      "${AppConstants.baseUrl}${AppConstants.fecthAssignedOrders}",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'sid=$sid',
        },
      );

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final data = raw['message'];

        if (data['success_key'] == 1) {
          final orders = data['data'];
          if (orders is List) {
            // Cache response
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(_cacheKey, jsonEncode(orders));

            return orders
                .map<OrderItemModel>((e) => OrderItemModel.fromJson(e))
                .toList();
          } else {
            throw Exception('Unexpected response format: data is not a list');
          }
        } else {
          throw Exception('API error: ${data['error'] ?? "Unknown error"}');
        }
      } else {
        throw Exception('Failed to fetch orders (${response.statusCode})');
      }
    } catch (e) {
      // If error occurs, try loading from cache
      print('⚠️ Network error: $e. Trying cached orders...');

      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);

      if (cached != null) {
        final List<dynamic> cachedOrders = jsonDecode(cached);
        return cachedOrders
            .map<OrderItemModel>((e) => OrderItemModel.fromJson(e))
            .toList();
      }

      rethrow; // if cache also fails
    }
  }
}
