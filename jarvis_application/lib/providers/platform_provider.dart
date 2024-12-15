import 'package:flutter/material.dart';

class PlatformProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _platforms = [
    {
      "name": "Slack",
      "icon": 'assets/slack.png',
      "status": "Not Configured",
    },
    {
      "name": "Telegram",
      "icon": 'assets/images/telegram.png',
      "status": "Not Configured",
    },
    {
      "name": "Messenger",
      "icon": 'assets/images/messenger.png',
      "status": "Not Configured",
    },
  ];

  List<Map<String, dynamic>> get platforms => _platforms;

  // Method to update platform status
  void updateStatus(String platformName, String newStatus) {
    final index = _platforms.indexWhere((platform) => platform['name'] == platformName);
    if (index != -1) {
      _platforms[index]['status'] = newStatus;
      notifyListeners();
    }
  }
}
