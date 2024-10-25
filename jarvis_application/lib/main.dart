import 'package:flutter/material.dart';
import 'package:jarvis_application/services/mock_ai_service.dart';
import 'package:jarvis_application/screens/aiBots/publish_screen.dart';
import 'package:jarvis_application/screens/aiBots/bot_list_page.dart';
import 'package:jarvis_application/ui/chat_page.dart';
import 'package:jarvis_application/viewmodels/email_compose_view_model.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:jarvis_application/views/auth/signin_page.dart';
import 'package:jarvis_application/views/email/email_compose_page.dart';
import 'package:provider/provider.dart';
import 'package:jarvis_application/providers/ai_bot_provider.dart';
import 'package:jarvis_application/providers/auth_provider.dart';
import 'package:jarvis_application/providers/platform_provider.dart'; // Import PlatformProvider
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AIBotProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
         ChangeNotifierProvider(create: (_) => ImageHandlerViewModel()),
      ],
      child: MaterialApp(
        title: 'Chat Bot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAuthenticated
        ? const MainScreen()
        : const SigninPage();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Offset _fabPosition = Offset(20, 20);
  bool _isDragging = false;

  static final List<Widget> _pages = <Widget>[
    const ChatPage(),
    const BotListPage(),
    const KnowledgeBase(),
    const PromptLibrary(),
    ChangeNotifierProvider(
      create: (context) => EmailComposeViewModel(MockAIService()),
      child: const EmailComposeScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Large screen layout
          return Scaffold(
            body: Row(
              children: <Widget>[
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
                    NavigationRailDestination(
                      icon: Icon(Icons.email),
                      selectedIcon: Icon(Icons.email_outlined),
                      label: Text('Email'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        } else {
          // Mobile screen layout
          return Scaffold(
            body: Stack(
              children: [
                _pages[_selectedIndex],
                Positioned(
                  left: _fabPosition.dx,
                  top: _fabPosition.dy,
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _fabPosition += details.delta;
                        // Ensure the FAB stays within the screen bounds
                        _fabPosition = Offset(
                          math.max(0, math.min(_fabPosition.dx, MediaQuery.of(context).size.width - 56)),
                          math.max(0, math.min(_fabPosition.dy, MediaQuery.of(context).size.height - 56)),
                        );
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: FloatingActionButton(
                      onPressed: _isDragging ? null : () => _showMobileMenu(context),
                      child: const Icon(Icons.smart_toy),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chat'),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Bot List'),
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('KB'),
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Prompts'),
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
