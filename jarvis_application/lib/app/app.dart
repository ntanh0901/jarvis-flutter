// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:jarvis_application/app/app_router.dart';
import 'package:jarvis_application/app/app_theme.dart';
import 'package:jarvis_application/ui/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';

import '../providers/platform_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageHandlerViewModel()),
        ChangeNotifierProvider(create: (_) => PlatformProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        title: 'Jarvis Application',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
