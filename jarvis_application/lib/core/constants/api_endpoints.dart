class ApiEndpoints {
  static const String signIn = '/api/v1/auth/sign-in';
  static const String signUp = '/api/v1/auth/sign-up';
  static const String signOut = '/api/v1/auth/sign-out';
  static const String getCurrentUser = '/api/v1/auth/me';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String googleSignIn = '/api/v1/auth/google-sign-in';
  static const String getConversations = '/api/v1/ai-chat/conversations';
  static const String responseEmail = '/api/v1/ai-email';
  static const String suggestReplyIdeas = '/api/v1/ai-email/reply-ideas';
  static const String kbSignIn = "/kb-core/v1/auth/external-sign-in";
}
