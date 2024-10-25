// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jarvis_application/viewmodels/chart_view_model.dart';
import 'package:jarvis_application/viewmodels/email_compose_view_model.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:jarvis_application/views/email/email_compose_page.dart';
import 'package:provider/provider.dart';
import 'package:jarvis_application/viewmodels/account_view_model.dart';
import 'package:jarvis_application/services/mock_ai_service.dart';
import 'package:jarvis_application/services/ai_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AIService>(create: (_) => MockAIService()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => ImageHandlerViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProxyProvider<AIService, EmailComposeViewModel>(
          create: (context) => EmailComposeViewModel(context.read<AIService>()),
          update: (context, aiService, previous) => 
            previous ?? EmailComposeViewModel(aiService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmailComposeScreen(),
    );
  }
}
