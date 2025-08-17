import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> requestPermissionIfNeeded() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // You can show a dialog to the user to change permissions manually
    }
  }
}
