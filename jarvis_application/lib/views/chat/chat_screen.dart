import 'package:flutter/material.dart';
import 'package:jarvis_application/viewmodels/chart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:jarvis_application/styles/chat_screen_styles.dart';
import 'package:jarvis_application/views/chat/image_input_section.dart';
import 'package:screenshot/screenshot.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScreenshotController screenshotController;

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Chat Screen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear_all,
                  color: ChatScreenStyles.iconColor),
              onPressed: () {
                context.read<ChatViewModel>().clearChat();
                context.read<ImageHandlerViewModel>().removeAllImages();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildChatMessages()),
            ImageInputSection(
              screenshotController: screenshotController,
              inputTextArea: _buildChatInput(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return Consumer<ChatViewModel>(
      builder: (context, chatViewModel, child) {
        return ListView.builder(
          itemCount: chatViewModel.messages.length,
          itemBuilder: (context, index) {
            final message = chatViewModel.messages[index];
            return ListTile(
              title: Text(
                message['message'] ?? '',
                style: TextStyle(
                  color:
                      message['sender'] == 'user' ? Colors.blue : Colors.green,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: context.read<ChatViewModel>().messageController,
            decoration: const InputDecoration(
              hintText: 'Type a message...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, color: ChatScreenStyles.iconColor),
          onPressed: () {
            final chatVM = context.read<ChatViewModel>();
            chatVM.sendMessage(chatVM.messageController.text);
          },
        ),
      ],
    );
  }
}
