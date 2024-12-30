import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/models/bot/publish_bot/platform.dart';
import '../data/models/bot/publish_bot/request/req_messenger_publish.dart';
import '../data/models/bot/publish_bot/request/req_slack_publish.dart';
import '../data/models/bot/publish_bot/request/req_telegram_publish.dart';

class PlatformProvider with ChangeNotifier {
  final List<Platform> _platforms = [
    Platform(name: "Slack", icon: 'assets/slack.png', status: false),
    Platform(name: "Telegram", icon: 'assets/images/telegram.png', status: false),
    Platform(name: "Messenger", icon: 'assets/images/messenger.png', status: false),
  ];

  final String baseUrl = 'https://knowledge-api.jarvis.cx';
  final String apiToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY4YzA4ZDNmLTIyMzEtNDE5Ni04ZTVmLTEzZDgwNjRlOWNkMSIsImVtYWlsIjoicXVhbmd0aGllbjEyMzRAZ21haWwuY29tIiwiaWF0IjoxNzM1NTE2ODE4LCJleHAiOjE3MzU2MDMyMTh9.kjYVBDGL6rv6zzV5oUFQpQptSfpayKTmyUPo6X1Xsis';

  List<Platform> get platforms => _platforms;

  // Add these variables to hold metadata for each platform.
  ReqTelegramPublish? telegramConfig;
  ReqSlackPublish? slackConfig;
  ReqMessengerPublish? messengerConfig;

  // Cập nhật trạng thái của một platform
  void updateStatus(String platformName, bool newStatus) {
    final index = _platforms.indexWhere((platform) => platform.name == platformName);
    if (index != -1) {
      _platforms[index].status = newStatus;
      notifyListeners();
    }
  }

  // Gửi yêu cầu xác thực Telegram Bot
  Future<void> verifyTelegramBot(String botToken, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/bot-integration/telegram/validation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'botToken': botToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isSuccessful = data['ok'] ?? false;

        if (isSuccessful) {
          updateStatus('Telegram', true);

          if(telegramConfig == null) {
            telegramConfig = ReqTelegramPublish(
              botToken: botToken,
            );
          }
          else {
            telegramConfig!.setAll(botToken);

          }

          print('Telegram ggggggggggggggggggggggggggg: ${telegramConfig?.toJson()}');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Telegram Bot verified successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification failed. Invalid Bot.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}. ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Gửi yêu cầu xác thực Messenger Bot
  Future<void> verifyMessengerBot({
    required String botToken,
    required String pageId,
    required String appSecret,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/bot-integration/messenger/validation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'botToken': botToken,
          'pageId': pageId,
          'appSecret': appSecret,
        }),
      );

      if (response.statusCode == 200) {

          updateStatus('Messenger', true);
          if (messengerConfig == null) {
            messengerConfig = ReqMessengerPublish(
              botToken: botToken,
              pageId: pageId,
              appSecret: appSecret,
            );
          } else {
            messengerConfig!.setAll(
              botToken, pageId, appSecret,
            );
          }


          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Messenger Bot configured successfully!')),
          );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Configuration failed ${response.statusCode}. ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  // Gửi yêu cầu xác thực Slack Bot
  Future<void> verifySlackBot({
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/bot-integration/slack/validation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(ReqSlackPublish(
          botToken: botToken,
          clientId: clientId,
          clientSecret: clientSecret,
          signingSecret: signingSecret,
        ).toJson()),
      );

      if (response.statusCode == 200) {
        updateStatus('Slack', true);
        if (slackConfig == null) {
          slackConfig = ReqSlackPublish(
            botToken: botToken,
            clientId: clientId,
            clientSecret: clientSecret,
            signingSecret: signingSecret,
          );
        } else {
          slackConfig!.setAll(botToken, clientId, clientSecret, signingSecret,
          );
        }        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slack Bot configured successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}. ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchPlatformConfigurations(String assistantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kb-core/v1/bot-integration/$assistantId/configurations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (var platformConfig in data) {
          final type = platformConfig['type'];
          final metadata = platformConfig['metadata'];

          if (type == 'telegram' && metadata != null) {
            updateStatus('Telegram', true);
            telegramConfig = ReqTelegramPublish.fromJson(metadata);
          } else if (type == 'slack' && metadata != null) {
            updateStatus('Slack', true);
            slackConfig = ReqSlackPublish.fromJson(metadata);
          } else if (type == 'messenger' && metadata != null) {
            updateStatus('Messenger', true);
            messengerConfig = ReqMessengerPublish.fromJson(metadata);
          }
        }
      } else {
        throw Exception('Failed to fetch platform configurations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching platform configurations: $e');
    }
  }

// Publish Telegram Bot
  Future<Map<String, String>> publishTelegramBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    final url = '$baseUrl/kb-core/v1/bot-integration/telegram/publish/$assistantId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(telegramConfig?.toJson()),
      );
      print('Telegram publish requestttttt: ${telegramConfig?.toJson()}');
      print('Telegram publish responseeeeee: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'platform': 'Telegram', 'redirect': data['redirect']};
      } else {
        throw Exception('Telegram publish failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Telegram: $e')),
      );
      rethrow;
    }
  }

  // Publish Slack Bot
  Future<Map<String, String>> publishSlackBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    final url = '$baseUrl/kb-core/v1/bot-integration/slack/publish/$assistantId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(slackConfig?.toJson()),
      );

      print('Slack publish responseeeeee: ${response.body}');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'platform': 'Slack', 'redirect': data['redirect']};
      } else {
        throw Exception('Slack publish failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Slack: $e')),
      );
      rethrow;
    }
  }

  // Publish Messenger Bot
  Future<Map<String, String>> publishMessengerBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    final url = '$baseUrl/kb-core/v1/bot-integration/messenger/publish/$assistantId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(messengerConfig?.toJson()),
      );

      print('Messenger publish responseeeeee: ${response.body}');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'platform': 'Messenger', 'redirect': data['redirect']};
      } else {
        throw Exception('Messenger publish failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Messenger: $e')),
      );
      rethrow;
    }
  }
}




