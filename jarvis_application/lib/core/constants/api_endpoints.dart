class ApiEndpoints {
  // Auth
  static const String signIn = '/api/v1/auth/sign-in';
  static const String signUp = '/api/v1/auth/sign-up';
  static const String signOut = '/api/v1/auth/sign-out';
  static const String getCurrentUser = '/api/v1/auth/me';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String googleSignIn = '/api/v1/auth/google-sign-in';

  // Token
  static const String getUsage = '/api/v1/tokens/usage';
  // Chat
  static const String getConversations = '/api/v1/ai-chat/conversations';

  // Prompt
  static const String getPrompts = '/api/v1/prompts';
  static const String createPrompt = '/api/v1/prompts';
  static const String updatePrompt = '/api/v1/prompts/{id}';
  static const String deletePrompt = '/api/v1/prompts/{id}';
  static const String addFavoritePrompt = '/api/v1/prompts/{id}/favorite';
  static const String removeFromFavorites = '/api/v1/prompts/{id}/favorite';

  // Email
  static const String responseEmail = '/api/v1/ai-email';
  static const String suggestReplyIdeas = '/api/v1/ai-email/reply-ideas';

  // Knowledge Base
  static const String kbSignIn = "/kb-core/v1/auth/external-sign-in";
  static const String createKB = "/kb-core/v1/knowledge";
  static const String getKB = "/kb-core/v1/knowledge";
  static const String updateKB = "/kb-core/v1/knowledge/{id}";
  static const String deleteKB = "/kb-core/v1/knowledge/{id}";
  static const String getKBUnits = "/kb-core/v1/knowledge/{id}/units";
  static const String localFile = "/kb-core/v1/knowledge/{id}/local-file";
  static const String website = "/kb-core/v1/knowledge/{id}/web";
  static const String slack = "/kb-core/v1/knowledge/{id}/slack";
  static const String confluence = "/kb-core/v1/knowledge/{id}/confluence";
}
