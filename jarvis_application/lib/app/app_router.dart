import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_application/data/models/prompt.dart';
import 'package:jarvis_application/ui/views/auth/forget_password_page.dart';
import 'package:jarvis_application/ui/views/auth/signin_page.dart';
import 'package:jarvis_application/ui/views/auth/signup_page.dart';
import 'package:jarvis_application/ui/views/chat/chat_page.dart';
import 'package:jarvis_application/ui/views/splash/splash_screen.dart';

import '../data/models/bot/ai_assistant.dart';
import '../data/services/auth_service.dart';
import '../ui/views/aiBots/bot_chat_page.dart';
import '../ui/views/aiBots/bot_list_page.dart';
import '../ui/views/aiBots/publish_page.dart';
import '../ui/views/aiBots/result_publish_page.dart';
import '../ui/views/email/email_reply_page.dart';
import '../ui/views/knowledgeBase/knowledge_base_screen.dart';
import '../ui/views/prompts/prompt_library_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
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
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'Chat',
        builder: (context, state) {
          final prompt = state.extra as Prompt?; // cast from state.extra
          return ChatPage(initialPrompt: prompt);
        },
      ),
      GoRoute(
        path: '/bot-list',
        builder: (context, state) => const BotListPage(),
        name: 'Bot List',
      ),
      GoRoute(
        path: '/bot-chat',
        builder: (context, state) {
          final assistant = state.extra as AIAssistant;
          final threadId = state.uri.queryParameters['openAiThreadId'];
          if (threadId == null) {
            throw Exception("openAiThreadId is required but was not provided.");
          }
          return BotChatPage(
            currentAssistant: assistant,
            openAiThreadId: threadId,
          );
        },
        name: 'Bot Chat',
      ),
      GoRoute(
        path: '/publish',
        builder: (context, state) {
          final assistant = state.extra as AIAssistant;
          return PublishingPlatformPage(currentAssistant: assistant);
        },
        name: 'Publishing Platform',
      ),
      GoRoute(
        path: '/result-publish',
        builder: (context, state) {
          final selectedPlatforms = state.extra
              as List<Map<String, dynamic>>; // Extract data from state.extra
          return ResultPublishPage(selectedPlatforms: selectedPlatforms);
        },
        name: 'Result Publish',
      ),
      GoRoute(
        path: '/knowledge-base',
        builder: (context, state) => const KnowledgeBase(),
        name: 'Knowledge Base',
      ),
      GoRoute(
        path: '/prompt-library',
        builder: (context, state) => const PromptLibrary(),
        name: 'Prompt Library',
      ),
      GoRoute(
        path: '/email-compose',
        builder: (context, state) => const WritingScreen(),
        name: 'Email Compose',
      ),
    ],
    redirect: (context, state) {
      final ref = ProviderScope.containerOf(context, listen: false);
      final authState = ref.read(authProvider);
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
