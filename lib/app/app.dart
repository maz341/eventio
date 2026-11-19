import 'package:eventio/core/database/app_database.dart';
import 'package:eventio/features/events/data/source/event_local_service.dart';
import 'package:eventio/features/events/data/source/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../features/events/data/source/events_api_service.dart';
import '../features/events/presentation/viewmodels/events_viewmodel.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';

class EventioApp extends StatelessWidget {
  const EventioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://127.0.0.1:3000',
    );

    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),

        Provider<AppDatabase>(create: (_) => AppDatabase()),

        Provider<EventsLocalService>(
          create: (context) => EventsLocalService(context.read<AppDatabase>()),
        ),

        Provider<EventsRepository>(
          create: (context) => EventsRepository(
            apiService: EventsApiService(
              client: context.read<http.Client>(),
              baseUrl: apiBaseUrl,
            ),
            localService: context.read<EventsLocalService>(),
          ),
        ),

        ChangeNotifierProvider<EventsViewModel>(
          lazy: false,
          create: (context) => EventsViewModel(context.read<EventsRepository>())
            ..loadEvents()
            ..loadBookmarks(),
        ),
      ],

      child: MaterialApp(
        title: 'Eventio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
