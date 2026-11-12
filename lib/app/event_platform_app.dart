import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'theme/app_theme.dart';

class EventPlatformApp extends StatelessWidget {
  const EventPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
