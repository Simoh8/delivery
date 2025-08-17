import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteService {
  static const String _apiKey = 'AIzaSyClcVmsDzi8fZ_pXoIzBqZHhXj7_Yvund0'; // secure this

  static Future<List<LatLng>> getDetailedRoutePolyline({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> waypoints = const [],
  }) async {
    final waypointStr = waypoints.isNotEmpty
        ? '&waypoints=${waypoints.map((w) => '${w.latitude},${w.longitude}').join('|')}'
        : '';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}$waypointStr&mode=driving&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> allPoints = [];

      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final legs = routes[0]['legs'];

        for (var leg in legs) {
          final steps = leg['steps'];
          for (var step in steps) {
            final polyline = step['polyline']['points'];
            allPoints.addAll(_decodePolyline(polyline));
          }
        }
      }

      return allPoints;
    } else {
      throw Exception('Failed to load route');
    }
  }

  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return polyline;
  }
}
