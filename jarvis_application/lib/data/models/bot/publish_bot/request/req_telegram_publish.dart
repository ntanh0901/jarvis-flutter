
class ReqTelegramPublish {
  final String botToken;

  ReqTelegramPublish({required this.botToken});

  factory ReqTelegramPublish.fromJson(Map<String, dynamic> json) {
    return ReqTelegramPublish(
      botToken: json['botToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
    };
  }

  @override
  String toString() {
    return 'ReqTelegramPublish{botToken: $botToken}';
  }
}
