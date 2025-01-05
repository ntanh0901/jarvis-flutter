/// ResVerifyBot Model
class ResVerifyBot {
  final bool ok;
  final BotResult result;

  ResVerifyBot({
    required this.ok,
    required this.result,
  });

  factory ResVerifyBot.fromJson(Map<String, dynamic> json) {
    return ResVerifyBot(
      ok: json['ok'] ?? false,
      result: BotResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'result': result.toJson(),
    };
  }

  @override
  String toString() {
    return 'ResVerifyBot{ok: $ok, result: $result}';
  }
}

/// BotResult Model
class BotResult {
  final int id;
  final bool isBot;
  final String firstName;
  final String username;
  final bool canJoinGroups;
  final bool canReadAllGroupMessages;
  final bool supportsInlineQueries;
  final bool canConnectToBusiness;
  final bool hasMainWebApp;

  BotResult({
    required this.id,
    required this.isBot,
    required this.firstName,
    required this.username,
    required this.canJoinGroups,
    required this.canReadAllGroupMessages,
    required this.supportsInlineQueries,
    required this.canConnectToBusiness,
    required this.hasMainWebApp,
  });

    factory BotResult.fromJson(Map<String, dynamic> json) {
    return BotResult(
      id: json['id'] ?? 0,
      isBot: json['is_bot'] ?? false,
      firstName: json['first_name'] ?? '',
      username: json['username'] ?? '',
      canJoinGroups: json['can_join_groups'] ?? false,
      canReadAllGroupMessages: json['can_read_all_group_messages'] ?? false,
      supportsInlineQueries: json['supports_inline_queries'] ?? false,
      canConnectToBusiness: json['can_connect_to_business'] ?? false,
      hasMainWebApp: json['has_main_web_app'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_bot': isBot,
      'first_name': firstName,
      'username': username,
      'can_join_groups': canJoinGroups,
      'can_read_all_group_messages': canReadAllGroupMessages,
      'supports_inline_queries': supportsInlineQueries,
      'can_connect_to_business': canConnectToBusiness,
      'has_main_web_app': hasMainWebApp,
    };
  }

  @override
  String toString() {
    return 'BotResult{id: $id, isBot: $isBot, firstName: $firstName, username: $username, canJoinGroups: $canJoinGroups, canReadAllGroupMessages: $canReadAllGroupMessages, supportsInlineQueries: $supportsInlineQueries, canConnectToBusiness: $canConnectToBusiness, hasMainWebApp: $hasMainWebApp}';
  }
}
