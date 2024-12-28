

class ReqSlackPublish {
  late final String botToken;
  late final String clientId;
  late final String clientSecret;
  late final String signingSecret;
  final String? redirect;

  ReqSlackPublish({
    required this.botToken,
    required this.clientId,
    required this.clientSecret,
    required this.signingSecret,
    this.redirect,
  });

  factory ReqSlackPublish.fromJson(Map<String, dynamic> json) {
    return ReqSlackPublish(
      botToken: json['botToken'] ?? '',
      clientId: json['clientId'] ?? '',
      clientSecret: json['clientSecret'] ?? '',
      signingSecret: json['signingSecret'] ?? '',
      redirect: json['redirect'],
    );
  }

  void setAll(String botToken, String clientId, String clientSecret, String signingSecret) {
    this.botToken = botToken;
    this.clientId = clientId;
    this.clientSecret = clientSecret;
    this.signingSecret = signingSecret;
  }

  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'signingSecret': signingSecret,
    };
  }

  @override
  String toString() {
    return 'ReqSlackPublish{botToken: $botToken, clientId: $clientId, clientSecret: $clientSecret, signingSecret: $signingSecret, redirect: $redirect}';
  }
}
