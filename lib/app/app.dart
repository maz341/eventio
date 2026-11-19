import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'splash_screen.dart';

class EventioApp extends StatelessWidget {
  const EventioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
