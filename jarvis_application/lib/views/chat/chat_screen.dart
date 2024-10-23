// lib/views/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:jarvis_application/viewmodels/chart_view_model.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<ChatViewModel>().clearChat();
              context.read<ImageHandlerViewModel>().clearImage();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, chatViewModel, child) {
                return ListView.builder(
                  itemCount: chatViewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatViewModel.messages[index];
                    return ListTile(
                      title: Text(
                        message['message'] ?? '',
                        style: TextStyle(
                          color: message['sender'] == 'user'
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Consumer<ImageHandlerViewModel>(
            builder: (context, imageHandler, child) {
              return imageHandler.selectedImage != null
                  ? Column(
                      children: [
                        Image.file(imageHandler.selectedImage!),
                        ElevatedButton(
                          onPressed: () {
                            final chatVM = context.read<ChatViewModel>();
                            chatVM.sendMessage('Image sent!');
                            imageHandler.clearImage();
                          },
                          child: const Text('Send Image'),
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          _buildChatInput(context),
          _buildImageOptions(context),
        ],
      ),
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
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            final chatVM = context.read<ChatViewModel>();
            chatVM.sendMessage(chatVM.messageController.text);
          },
        ),
      ],
    );
  }

  Widget _buildImageOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<ImageHandlerViewModel>().pickImage();
          },
          child: const Text('Upload Photo'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ImageHandlerViewModel>().takePhoto();
          },
          child: const Text('Take Photo'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ImageHandlerViewModel>().captureScreenshot(context);
          },
          child: const Text('Screenshot'),
        ),
      ],
    );
  }
}
