import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/bot/publish_bot/platform.dart';
import '../data/models/bot/publish_bot/request/req_messenger_publish.dart';
import '../data/models/bot/publish_bot/request/req_slack_publish.dart';
import '../data/models/bot/publish_bot/request/req_telegram_publish.dart';
import 'dio_provider.dart';

final platformProvider = ChangeNotifierProvider((ref) => PlatformProvider(ref));

class PlatformProvider with ChangeNotifier {
  final Ref _ref;

  PlatformProvider(this._ref);

  final List<Platform> _platforms = [
    Platform(name: "Slack", icon: 'assets/slack.png', status: false),
    Platform(
        name: "Telegram", icon: 'assets/images/telegram.png', status: false),
    Platform(
        name: "Messenger", icon: 'assets/images/messenger.png', status: false),
  ];

  List<Platform> get platforms => _platforms;

  ReqTelegramPublish? telegramConfig;
  ReqSlackPublish? slackConfig;
  ReqMessengerPublish? messengerConfig;

  void updateStatus(String platformName, bool newStatus) {
    final index =
        _platforms.indexWhere((platform) => platform.name == platformName);
    if (index != -1) {
      _platforms[index].status = newStatus;
      notifyListeners();
    }
  }

  Future<void> verifyTelegramBot(String botToken, BuildContext context) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final response = await dioKB.dio.post(
        '/kb-core/v1/bot-integration/telegram/validation',
        data: {'botToken': botToken},
      );

      final isSuccessful = response.data['ok'] ?? false;

      if (isSuccessful) {
        updateStatus('Telegram', true);
        if (telegramConfig == null) {
          telegramConfig = ReqTelegramPublish(botToken: botToken);
        } else {
          telegramConfig!.setAll(botToken);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telegram Bot verified successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification failed. Invalid Bot.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> verifyMessengerBot({
    required String botToken,
    required String pageId,
    required String appSecret,
    required BuildContext context,
  }) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      await dioKB.dio.post(
        '/kb-core/v1/bot-integration/messenger/validation',
        data: {
          'botToken': botToken,
          'pageId': pageId,
          'appSecret': appSecret,
        },
      );

      updateStatus('Messenger', true);
      if (messengerConfig == null) {
        messengerConfig = ReqMessengerPublish(
          botToken: botToken,
          pageId: pageId,
          appSecret: appSecret,
        );
      } else {
        messengerConfig!.setAll(botToken, pageId, appSecret);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Messenger Bot configured successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> verifySlackBot({
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
    required BuildContext context,
  }) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final slackData = ReqSlackPublish(
        botToken: botToken,
        clientId: clientId,
        clientSecret: clientSecret,
        signingSecret: signingSecret,
      );

      await dioKB.dio.post(
        '/kb-core/v1/bot-integration/slack/validation',
        data: slackData.toJson(),
      );

      updateStatus('Slack', true);
      if (slackConfig == null) {
        slackConfig = slackData;
      } else {
        slackConfig!.setAll(botToken, clientId, clientSecret, signingSecret);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slack Bot configured successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchPlatformConfigurations(String assistantId) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final response = await dioKB.dio.get(
        '/kb-core/v1/bot-integration/$assistantId/configurations',
      );

      final List<dynamic> data = response.data;

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
    } catch (e) {
      throw Exception('Error fetching platform configurations: $e');
    }
  }

  Future<Map<String, String>> publishTelegramBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final response = await dioKB.dio.post(
        '/kb-core/v1/bot-integration/telegram/publish/$assistantId',
        data: telegramConfig?.toJson(),
      );

      return {
        'platform': 'Telegram',
        'redirect': response.data['redirect'],
      };
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Telegram: $e')),
      );
      rethrow;
    }
  }

  Future<Map<String, String>> publishSlackBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final response = await dioKB.dio.post(
        '/kb-core/v1/bot-integration/slack/publish/$assistantId',
        data: slackConfig?.toJson(),
      );

      return {
        'platform': 'Slack',
        'redirect': response.data['redirect'],
      };
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Slack: $e')),
      );
      rethrow;
    }
  }

  Future<Map<String, String>> publishMessengerBot({
    required String assistantId,
    required BuildContext context,
  }) async {
    try {
      final dioKB = _ref.read(dioKBProvider);
      final response = await dioKB.dio.post(
        '/kb-core/v1/bot-integration/messenger/publish/$assistantId',
        data: messengerConfig?.toJson(),
      );

      return {
        'platform': 'Messenger',
        'redirect': response.data['redirect'],
      };
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing Messenger: $e')),
      );
      rethrow;
    }
  }
}
