
class ReqMessengerPublish {
  late final String botToken;
  late final String pageId;
  late final String appSecret;
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

  void setAll(String botToken, String pageId, String appSecret) {
    this.botToken = botToken;
    this.pageId = pageId;
    this.appSecret = appSecret;
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
