// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/bot_list_page.dart';
import 'package:jarvis_application/ui/chat_page.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:jarvis_application/providers/ai_bot_provider.dart'; // Import AIBotProvider
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AIBotProvider()), // Cung cấp AIBotProvider
      ],
      child: MaterialApp(
        title: 'Chat Bot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    ChatPage(),
    BotListPage(),
    KnowledgeBase(),
    PromptLibrary(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: _pages[_selectedIndex],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.chat),
                selectedIcon: Icon(Icons.chat_bubble),
                label: Text('Chat'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                selectedIcon: Icon(Icons.list_alt),
                label: Text('Bot List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                selectedIcon: Icon(Icons.bookmark),
                label: Text('KB'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.lightbulb),
                selectedIcon: Icon(Icons.lightbulb_outline),
                label: Text('Prompts'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
