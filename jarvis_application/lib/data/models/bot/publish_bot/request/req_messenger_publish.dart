
class ReqMessengerPublish {
  final String botToken;
  final String pageId;
  final String appSecret;
  final String? redirect;

  ReqMessengerPublish({
    required this.botToken,
    required this.pageId,
    required this.appSecret,
    this.redirect,
  });

  factory ReqMessengerPublish.fromJson(Map<String, dynamic> json) {
    return ReqMessengerPublish(
      botToken: json['botToken'] ?? '',
      pageId: json['pageId'] ?? '',
      appSecret: json['appSecret'] ?? '',
      redirect: json['redirect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
      'pageId': pageId,
      'appSecret': appSecret,
    };
  }

  @override
  String toString() {
    return 'ReqMessengerPublish{botToken: $botToken, pageId: $pageId, appSecret: $appSecret, redirect: $redirect}';
  }
}
