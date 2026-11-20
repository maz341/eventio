import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

class DistanceCalculator {
  const DistanceCalculator();

  double kilometersBetween(AppCoordinates start, AppCoordinates destination) {
    final meters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      destination.latitude,
      destination.longitude,
    );

    return meters / 1000;
  }
}
