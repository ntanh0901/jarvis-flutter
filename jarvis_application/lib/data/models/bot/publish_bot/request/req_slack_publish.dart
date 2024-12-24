

class ReqSlackPublish {
  final String botToken;
  final String clientId;
  final String clientSecret;
  final String signingSecret;
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
