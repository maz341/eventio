import 'dart:io';
import 'dart:ui';

import 'package:eventio/features/events/data/source/event_local_service.dart';
import 'package:eventio/features/events/data/source/event_repository.dart';
import 'package:eventio/features/events/data/source/events_api_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

import '../database/app_database.dart';

const refreshEventsTask = 'refresh_events';

@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != refreshEventsTask &&
        taskName != Workmanager.iOSBackgroundTask) {
      return true;
    }

    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final client = http.Client();

    try {
      const baseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://127.0.0.1:3000',
      );


      final database = AppDatabase();


      final localService = EventsLocalService(database);

      final repository = EventsRepository(
        apiService: EventsApiService(client: client, baseUrl: baseUrl),
        localService: localService,
      );


      final result = await repository.getEvents(forceRefresh: true);

      debugPrint('Background refresh completed: ${!result.isStale}');

      return !result.isStale;
    } catch (error) {
      debugPrint('Background refresh failed: $error');
      return false;
    } finally {
      client.close();
    }
  });
}

class BackgroundRefreshService {
  const BackgroundRefreshService();

  Future<void> initialize() async {
    await Workmanager().initialize(backgroundCallbackDispatcher);

    if (Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        'eventio-events-refresh',
        refreshEventsTask,
        frequency: const Duration(hours: 6),
        constraints: Constraints(networkType: NetworkType.connected),
      );
    }
  }
}
