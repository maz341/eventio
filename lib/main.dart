import 'package:eventio/app/app.dart';
import 'package:eventio/core/background/background_refresh_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

    WidgetsFlutterBinding.ensureInitialized();

  await const BackgroundRefreshService().initialize();

  runApp(const EventioApp());
}
