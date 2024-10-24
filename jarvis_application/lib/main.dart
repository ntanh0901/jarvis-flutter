import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/bot_list_page.dart';
import 'package:jarvis_application/ui/chat_page.dart';
import 'package:jarvis_application/ui/home_page.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:jarvis_application/providers/ai_bot_provider.dart'; // Import AIBotProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AIBotProvider()), // Cung cấp AIBotProvider
      ],
      child: MaterialApp(
        title: 'Chat Bot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          ChatPage.routeName: (context) => const ChatPage(),
          BotListPage.routeName: (context) => BotListPage(),
        },
      ),
    );
  }
}
