import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_application/viewmodels/email_compose_view_model.dart';
import 'package:provider/provider.dart';

class EmailComposeScreen extends StatelessWidget {
  const EmailComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmailComposeViewModel>(
      create: (context) => EmailComposeViewModel(),
      child: Consumer<EmailComposeViewModel>(
        builder: (context, emailViewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Email Reply Simulation with AI'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    emailViewModel.reset();
                  },
                  tooltip: 'New Chat',
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: emailViewModel.conversationHistory.length,
                      itemBuilder: (context, index) {
                        final message =
                            emailViewModel.conversationHistory[index];
                        final isUser = message['role'] == 'user';
                        final responses = message['responses'] as List<String>;
                        final currentResponseIndex =
                            message['currentResponseIndex'] as int;
                        final content = isUser
                            ? message['content']
                            : responses[currentResponseIndex];

                        return Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.grey[200]
                                    : Colors.blue[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            if (!isUser)
                              _ResponseActions(
                                emailViewModel: emailViewModel,
                                requestIndex: index,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                _ChatInputWidget(emailViewModel: emailViewModel),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResponseActions extends StatelessWidget {
  final EmailComposeViewModel emailViewModel;
  final int requestIndex;

  const _ResponseActions({
    super.key,
    required this.emailViewModel,
    required this.requestIndex,
  });

  @override
  Widget build(BuildContext context) {
    final message = emailViewModel.conversationHistory[requestIndex];
    final responses = message['responses'] as List<String>;
    final currentResponseIndex = message['currentResponseIndex'] as int;

    final isAtStart = currentResponseIndex == 0;
    final isAtEnd = currentResponseIndex == responses.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            final response = responses[currentResponseIndex];
            Clipboard.setData(ClipboardData(text: response));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Response copied to clipboard')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            emailViewModel.refreshResponse(requestIndex);
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isAtStart ? null : () {
            emailViewModel.navigateResponse(requestIndex, false);
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: isAtEnd ? null : () {
            emailViewModel.navigateResponse(requestIndex, true);
          },
        ),
      ],
    );
  }
}

class _ChatInputWidget extends StatefulWidget {
  final EmailComposeViewModel emailViewModel;

  const _ChatInputWidget({super.key, required this.emailViewModel});

  @override
  State<_ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<_ChatInputWidget> {
  late TextEditingController chatController;

  @override
  void initState() {
    super.initState();
    chatController = TextEditingController();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              decoration: const InputDecoration(
                hintText: "Type your request here...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (chatController.text.isNotEmpty) {
                widget.emailViewModel.setUserInput(chatController.text);
                widget.emailViewModel.simulateAICall(chatController.text);
                chatController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
