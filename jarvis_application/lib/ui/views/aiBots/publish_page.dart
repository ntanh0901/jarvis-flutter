import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_application/ui/views/aiBots/result_publish_page.dart';
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
  List<bool> _selectedPlatforms = [];
  final String baseUrl = 'https://knowledge-api.jarvis.cx';

  @override
  void initState() {
    super.initState();
    final platformProvider = Provider.of<PlatformProvider>(context, listen: false);

    _selectedPlatforms = List<bool>.filled(platformProvider.platforms.length, false);
    platformProvider.fetchPlatformConfigurations(widget.currentAssistant.id).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    });
  }

  bool get _hasSelectedPlatforms {
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _selectedPlatforms[index],
                            onChanged: platform.status
                                ? (bool? value) {
                              setState(() {
                                _selectedPlatforms[index] = value ?? false;
                              });
                            }
                                : null,
                          ),
                          Image.asset(
                            platform.icon,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  platform.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  platform.status ? "Configured" : "Not Configured",
                                  style: TextStyle(
                                    color: platform.status ? Colors.green : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              if (platform.name == 'Messenger') {
                                _showMessengerConfigDialog(context, platformProvider);
                              } else if (platform.name == 'Slack') {
                                _showSlackConfigDialog(context, platformProvider);
                              } else if (platform.name == 'Telegram') {
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasSelectedPlatforms
                        ? () async {
                      List<Map<String, dynamic>> selectedPlatformResponses = [];
                      final platformProvider =
                      Provider.of<PlatformProvider>(context, listen: false);

                      for (int i = 0; i < platformProvider.platforms.length; i++) {
                        if (_selectedPlatforms[i]) {
                          final platform = platformProvider.platforms[i];
                          try {
                            Map<String, String>? response;

                            if (platform.name == 'Telegram') {
                              response = await platformProvider.publishTelegramBot(
                                assistantId: widget.currentAssistant.id,
                                context: context,
                              );
                            } else if (platform.name == 'Slack') {
                              response = await platformProvider.publishSlackBot(
                                assistantId: widget.currentAssistant.id,
                                context: context,
                              );
                            } else if (platform.name == 'Messenger') {
                              response = await platformProvider.publishMessengerBot(
                                assistantId: widget.currentAssistant.id,
                                context: context,
                              );
                            }

                            if (response != null) {
                              selectedPlatformResponses.add({
                                'name': platform.name,
                                'icon': platform.icon,
                                'status': true,
                                'redirect': response['redirect'],
                              });
                            }
                          } catch (e) {
                            // Error already handled in PlatformProvider
                          }
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPublishPage(
                            selectedPlatforms: selectedPlatformResponses,
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasSelectedPlatforms ? Colors.blue : Colors.grey,
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
    final scaffoldContext = context;

    final metadata = platformProvider.messengerConfig;
    if (metadata != null) {
      tokenController.text = metadata.botToken;
      pageIdController.text = metadata.pageId;
      appSecretController.text = metadata.appSecret;
    }

    final String callbackUrl =
        "$baseUrl/kb-core/v1/hook/messenger/${widget.currentAssistant.id}";
    const String verifyToken = "knowledge";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Messenger Configuration'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Messenger Bot Token', tokenController),
                const SizedBox(height: 10),
                _buildTextField('Messenger Page ID', pageIdController),
                const SizedBox(height: 10),
                _buildTextField('Messenger App Secret', appSecretController),
                const SizedBox(height: 20),

                const Text(
                  "Messenger copylink",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                _buildCopyableRow("Callback URL", callbackUrl),
                const SizedBox(height: 10),
                _buildCopyableRow("Verify Token", verifyToken),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final botToken = tokenController.text.trim();
                final pageId = pageIdController.text.trim();
                final appSecret = appSecretController.text.trim();

                if (botToken.isEmpty || pageId.isEmpty || appSecret.isEmpty) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text('All fields are required!')),
                  );
                  return;
                }

                Navigator.of(context, rootNavigator: true).pop();

                try {
                  await platformProvider.verifyMessengerBot(
                    botToken: botToken,
                    pageId: pageId,
                    appSecret: appSecret,
                    context: scaffoldContext,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
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
    final scaffoldContext = context;

    final metadata = platformProvider.slackConfig;
    if (metadata != null) {
      tokenController.text = metadata.botToken;
      clientIdController.text = metadata.clientId;
      clientSecretController.text = metadata.clientSecret;
      signingSecretController.text = metadata.signingSecret;
    }

    final String oauth2RedirectUrl =
        "$baseUrl/kb-core/v1/bot-integration/slack/auth/${widget.currentAssistant.id}";
    final String eventRequestUrl =
        "$baseUrl/kb-core/v1/hook/slack/${widget.currentAssistant.id}";
    final String slashRequestUrl =
        "$baseUrl/kb-core/v1/hook/slack/slash/${widget.currentAssistant.id}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Slack Configuration'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Slack Bot Token', tokenController),
                const SizedBox(height: 10),
                _buildTextField('Client ID', clientIdController),
                const SizedBox(height: 10),
                _buildTextField('Client Secret', clientSecretController),
                const SizedBox(height: 10),
                _buildTextField('Signing Secret', signingSecretController),
                const SizedBox(height: 20),

                const Text(
                  "Slack copylink",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                _buildCopyableRow("OAuth2 Redirect URLs", oauth2RedirectUrl),
                const SizedBox(height: 10),
                _buildCopyableRow("Event Request URL", eventRequestUrl),
                const SizedBox(height: 10),
                _buildCopyableRow("Slash Request URL", slashRequestUrl),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final botToken = tokenController.text.trim();
                final clientId = clientIdController.text.trim();
                final clientSecret = clientSecretController.text.trim();
                final signingSecret = signingSecretController.text.trim();

                if (botToken.isEmpty ||
                    clientId.isEmpty ||
                    clientSecret.isEmpty ||
                    signingSecret.isEmpty) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text('All fields are required!')),
                  );
                  return;
                }

                Navigator.of(context, rootNavigator: true).pop();

                try {
                  await platformProvider.verifySlackBot(
                    botToken: botToken,
                    clientId: clientId,
                    clientSecret: clientSecret,
                    signingSecret: signingSecret,
                    context: scaffoldContext,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
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
    final scaffoldContext = context;

    final metadata = platformProvider.telegramConfig;
    if (metadata != null) {
      tokenController.text = metadata.botToken;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Telegram Configuration'),
          content: Column(
            children: [
              _buildTextField('Telegram Bot Token', tokenController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final botToken = tokenController.text.trim();
                if (botToken.isEmpty) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text('Bot Token cannot be empty!')),
                  );
                  return;
                }

                Navigator.of(context, rootNavigator: true).pop();

                try {
                  await platformProvider.verifyTelegramBot(botToken, scaffoldContext);
                } catch (e) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.grey),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label copied to clipboard!')),
            );
          },
        ),
      ],
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
