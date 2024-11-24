// lib/app/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_application/screens/aiBots/bot_list_page.dart';
import 'package:jarvis_application/screens/aiBots/publish_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';
import 'package:jarvis_application/ui/chat_page.dart';
import 'package:jarvis_application/ui/views/auth/forget_password_page.dart';
import 'package:jarvis_application/ui/views/auth/signin_page.dart';
import 'package:jarvis_application/ui/views/auth/signup_page.dart';
import 'package:jarvis_application/ui/views/main_screen.dart';
import 'package:jarvis_application/ui/views/splash/splash_screen.dart';

import '../providers/auth_notifier.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/main-screen',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage()),
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
        builder: (context, state) => const PromptLibrary(),
      ),
    ],
    redirect: (context, state) {
      final ref = ProviderScope.containerOf(context, listen: false);
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isAuthPage = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up' ||
          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isAuthPage) {
        return '/sign-in';
      }
      if (isAuthenticated && (state.matchedLocation == '/' || isAuthPage)) {
        return '/chat';
      }
      return null;
    },
  );
}
