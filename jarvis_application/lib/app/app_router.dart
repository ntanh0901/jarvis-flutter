// lib/app/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:jarvis_application/data/services/mock_ai_service.dart';
import 'package:jarvis_application/providers/auth_provider.dart';
import 'package:jarvis_application/screens/aiBots/publish_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';
import 'package:jarvis_application/ui/viewmodels/email_compose_view_model.dart';
import 'package:jarvis_application/ui/views/auth/signin_page.dart';
import 'package:jarvis_application/ui/views/email/email_compose_page.dart';
import 'package:jarvis_application/ui/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import '../screens/aiBots/bot_list_page.dart';
import '../ui/chat_page.dart';
import '../ui/views/auth/signup_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: '/bot-list',
        builder: (context, state) => const BotListPage(),
      ),
      GoRoute(
        path: '/publish',
        builder: (context, state) => const PublishingPlatformPage(),
      ),
      GoRoute(
        path: '/knowledge-base',
        builder: (context, state) => const KnowledgeBase(),
      ),
      GoRoute(
        path: '/prompt-library',
        builder: (context, state) => const PromptLibrary(),
      ),
      GoRoute(
        path: '/email-compose',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => EmailComposeViewModel(MockAIService()),
          child: const EmailComposeScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/sign-in';

      if (!isAuthenticated && !isLoggingIn) {
        return '/sign-in';
      }
      if (isAuthenticated &&
          (state.matchedLocation == '/' ||
              state.matchedLocation == '/sign-in')) {
        return '/chat';
      }
      return null;
    },
  );
}