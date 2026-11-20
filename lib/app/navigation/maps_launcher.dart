import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsLauncher {
  const MapsLauncher();

  Future<bool> openDirections({
    required double latitude,
    required double longitude,
  }) {
    final destination = '$latitude,$longitude';

    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.https('maps.apple.com', '/', {
            'daddr': destination,
            'dirflg': 'd',
          })
        : Uri.https('www.google.com', '/maps/dir/', {
            'api': '1',
            'destination': destination,
            'travelmode': 'driving',
          });

    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
