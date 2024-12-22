import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/bot/ai_assistant.dart';
import '../../../providers/platform_provider.dart';

class PublishingPlatformPage extends StatefulWidget {
  static const String routeName = '/publish';

  final AIAssistant currentAssistant;

  const PublishingPlatformPage({
    super.key,
    required this.currentAssistant,
  });

  @override
  _PublishingPlatformPageState createState() => _PublishingPlatformPageState();
}

class _PublishingPlatformPageState extends State<PublishingPlatformPage> {
  // Danh sách các trạng thái của checkbox cho từng platform
  List<bool> _selectedPlatforms = [];

  @override
  void initState() {
    super.initState();
    final platformProvider = Provider.of<PlatformProvider>(context, listen: false);

    _selectedPlatforms =  List<bool>.filled(platformProvider.platforms.length, false);
  }

  bool get _hasSelectedPlatforms {
    // Kiểm tra nếu có bất kỳ platform nào được chọn
    return _selectedPlatforms.contains(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publishing Platform - ${widget.currentAssistant.assistantName}"),
        centerTitle: true,
      ),
      body: Consumer<PlatformProvider>(
        builder: (context, platformProvider, child) {
          final platforms = platformProvider.platforms;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: platforms.length,
                  itemBuilder: (context, index) {
                    final platform = platforms[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          // Checkbox để lựa chọn platform
                          Checkbox(
                            value: _selectedPlatforms[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedPlatforms[index] = value ?? false;
                              });
                            },
                          ),
                          Image.asset(
                            platform['icon'],
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              platform['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              if (platform['name'] == 'Messenger') {
                                _showMessengerConfigDialog(context, platformProvider);
                              } else if (platform['name'] == 'Slack') {
                                _showSlackConfigDialog(context, platformProvider);
                              } else if (platform['name'] == 'Telegram') {
                                _showTelegramConfigDialog(context, platformProvider);
                              }
                            },
                            child: const Text(
                              'Configure',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Nút Publish ở cuối trang
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasSelectedPlatforms
                        ? () {
                            // Hành động khi nhấn nút Publish
                            print("Published for ${widget.currentAssistant.assistantName}");
                          }
                        : null, // Disable nếu không có platform nào được chọn
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasSelectedPlatforms
                          ? Colors.blue
                          : Colors
                              .grey, // Xám khi không có selected, xanh dương khi có
                    ),
                    child: const Text('Publish'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMessengerConfigDialog(
      BuildContext context, PlatformProvider platformProvider) {
    final TextEditingController tokenController = TextEditingController();
    final TextEditingController pageIdController = TextEditingController();
    final TextEditingController appSecretController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Messenger Configuration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Messenger Bot Token', tokenController),
              const SizedBox(height: 10),
              _buildTextField('Messenger Bot Page ID', pageIdController),
              const SizedBox(height: 10),
              _buildTextField('Messenger Bot App Secret', appSecretController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final token = tokenController.text.trim();
                final pageId = pageIdController.text.trim();
                final appSecret = appSecretController.text.trim();

                // Add your logic to handle these values if necessary
                platformProvider.updateStatus('Messenger', 'Configured');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _showSlackConfigDialog(
      BuildContext context, PlatformProvider platformProvider) {
    final TextEditingController tokenController = TextEditingController();
    final TextEditingController clientIdController = TextEditingController();
    final TextEditingController clientSecretController = TextEditingController();
    final TextEditingController signingSecretController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Slack Configuration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Slack Bot Token', tokenController),
              const SizedBox(height: 10),
              _buildTextField('Client ID', clientIdController),
              const SizedBox(height: 10),
              _buildTextField('Client Secret', clientSecretController),
              const SizedBox(height: 10),
              _buildTextField('Signing Secret', signingSecretController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                platformProvider.updateStatus('Slack', 'Configured');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTelegramConfigDialog(
      BuildContext context, PlatformProvider platformProvider) {
    final TextEditingController tokenController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Telegram Configuration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Telegram Bot Token', tokenController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                platformProvider.updateStatus('Telegram', 'Configured');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }





  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

}
