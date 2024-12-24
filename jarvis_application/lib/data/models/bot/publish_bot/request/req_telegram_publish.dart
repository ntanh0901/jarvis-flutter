
class ReqTelegramPublish {
  final String botToken;
  final String? redirect;

  ReqTelegramPublish({
    required this.botToken,
    this.redirect,});

  factory ReqTelegramPublish.fromJson(Map<String, dynamic> json) {
    return ReqTelegramPublish(
      botToken: json['botToken'] ?? '',
      redirect: json['redirect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
    };
  }

  @override
  String toString() {
    return 'ReqTelegramPublish{botToken: $botToken, redirect: $redirect}';
  }
}
