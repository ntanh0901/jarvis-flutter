// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:jarvis_application/app/app_router.dart';
import 'package:jarvis_application/app/app_theme.dart';
import 'package:jarvis_application/providers/ai_bot_provider.dart';
import 'package:jarvis_application/providers/auth_provider.dart';
import 'package:jarvis_application/ui/viewmodels/email_compose_view_model.dart';
import 'package:jarvis_application/ui/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';

import '../core/di/service_locator.dart';
import '../data/services/mock_ai_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AIBotProvider()),
        ChangeNotifierProvider(create: (context) => getIt<AuthProvider>()),
        ChangeNotifierProvider(
            create: (context) => EmailComposeViewModel(MockAIService())),
        ChangeNotifierProvider(create: (context) => ImageHandlerViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        title: 'Jarvis Application',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
