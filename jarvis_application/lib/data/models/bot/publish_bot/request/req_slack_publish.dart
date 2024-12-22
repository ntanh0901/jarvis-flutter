

class ReqSlackPublish {
  final String botToken;
  final String clientId;
  final String clientSecret;
  final String signingSecret;

  ReqSlackPublish({
    required this.botToken,
    required this.clientId,
    required this.clientSecret,
    required this.signingSecret,
  });

  factory ReqSlackPublish.fromJson(Map<String, dynamic> json) {
    return ReqSlackPublish(
      botToken: json['botToken'] ?? '',
      clientId: json['clientId'] ?? '',
      clientSecret: json['clientSecret'] ?? '',
      signingSecret: json['signingSecret'] ?? '',
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
    return 'ReqSlackPublish{botToken: $botToken, clientId: $clientId, clientSecret: $clientSecret, signingSecret: $signingSecret}';
  }
}
