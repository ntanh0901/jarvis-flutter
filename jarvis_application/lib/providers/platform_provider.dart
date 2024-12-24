import 'package:flutter/material.dart';

import '../data/models/bot/publish_bot/platform.dart';

class PlatformProvider with ChangeNotifier {
  final List<Platform> _platforms = [
    Platform(name: "Slack", icon: 'assets/slack.png', status: false),
    Platform(name: "Telegram", icon: 'assets/images/telegram.png', status: false),
    Platform(name: "Messenger", icon: 'assets/images/messenger.png', status: false),
  ];

  List<Platform> get platforms => _platforms;

  // Method to update platform status
  void updateStatus(String platformName, bool newStatus) {
    final index = _platforms.indexWhere((platform) => platform.name == platformName);
    if (index != -1) {
      _platforms[index].status = newStatus;
      notifyListeners();
    }
  }
}
