

import 'dart:async';

import 'package:geolocator/geolocator.dart';

class AppCoordinates {
  const AppCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class LocationFailure implements Exception {
  const LocationFailure(this.message);

  final String message;
}

class LocationService {
  Future<AppCoordinates> getCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      throw const LocationFailure(
        'Location services are disabled. Enable them in Settings.',
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
        'Location access is blocked. Enable it in the app settings.',
      );
    }

    if (permission == LocationPermission.denied) {
      throw const LocationFailure('Location permission was denied.');
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return AppCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on TimeoutException {
      throw const LocationFailure(
        'Could not determine your location. Please try again.',
      );
    }
  }
}
