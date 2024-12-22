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
                                _showMessengerConfigDialog(
                                    context, platformProvider);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Messenger Configuration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Messenger Bot Token'),
              const SizedBox(height: 10),
              _buildTextField('Messenger Bot Page ID'),
              const SizedBox(height: 10),
              _buildTextField('Messenger Bot App Secret'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
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

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
