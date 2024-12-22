
class ReqMessagePublish {
  final String botToken;
  final String pageId;
  final String appSecret;

  ReqMessagePublish({
    required this.botToken,
    required this.pageId,
    required this.appSecret,
  });

  factory ReqMessagePublish.fromJson(Map<String, dynamic> json) {
    return ReqMessagePublish(
      botToken: json['botToken'] ?? '',
      pageId: json['pageId'] ?? '',
      appSecret: json['appSecret'] ?? '',
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
    return 'ReqMessagePublish{botToken: $botToken, pageId: $pageId, appSecret: $appSecret}';
  }
}
