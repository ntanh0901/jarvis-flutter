import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis_application/viewmodels/chart_view_model.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              Provider.of<ChatViewModel>(context, listen: false).clearChat();
              Provider.of<ImageHandlerViewModel>(context, listen: false)
                  .removeAllImages();
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
          _buildChatInput(context),
        ],
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ImageHandlerViewModel>(
              builder: (context, imageHandler, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            children: imageHandler.selectedImages
                                .asMap()
                                .entries
                                .map((entry) {
                              int idx = entry.key;
                              File imageFile = entry.value;
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    width: 40,
                                    height: 40,
                                    child: Image.file(imageFile,
                                        fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        imageHandler.removeImageAt(idx);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        if (imageHandler.selectedImages.isNotEmpty)
                          Tooltip(
                            message: 'Remove All Images',
                            child: IconButton(
                              icon: const Icon(Icons.delete_sweep_outlined),
                              onPressed: () => imageHandler.removeAllImages(),
                            ),
                          ),
                      ],
                    ),
                    if (!imageHandler.canAddMoreImages)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Max image limit reached',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),
            Row(
              children: [
                Consumer<ImageHandlerViewModel>(
                  builder: (context, imageHandler, child) {
                    return Tooltip(
                      message:
                          'Add Images (${imageHandler.selectedImageCount}/${ImageHandlerViewModel.maxImages})',
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: imageHandler.canAddMoreImages
                            ? () => _showOptionMenu(context)
                            : null,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Consumer<ChatViewModel>(
                    builder: (context, chatViewModel, _) {
                      return TextField(
                        controller: chatViewModel.messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
                Consumer<ChatViewModel>(
                  builder: (context, chatViewModel, _) {
                    return IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: () {
                        chatViewModel
                            .sendMessage(chatViewModel.messageController.text);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Provider.of<ImageHandlerViewModel>(context,
                        listen: false)
                    .pickImages();
                _showImageAddedFeedback(context, result);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Provider.of<ImageHandlerViewModel>(context,
                        listen: false)
                    .takePhoto();
                _showImageAddedFeedback(context, result);
              },
            ),
            ListTile(
              leading: const Icon(Icons.screenshot_outlined),
              title: const Text('Capture Screenshot'),
              onTap: () async {
                Navigator.pop(context);
                // Implement screenshot functionality
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageAddedFeedback(
      BuildContext context, Map<String, dynamic> result) {
    if (result['added'] > 0) {
      // Use a callback to show the SnackBar after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Added ${result['added']} image(s). Total: ${result['totalSelected']}/${ImageHandlerViewModel.maxImages}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });

      if (result['limitReached']) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Image limit reached. You can add up to ${ImageHandlerViewModel.maxImages} images.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }

      void _pickImages(BuildContext context) async {
        final imageHandler =
            Provider.of<ImageHandlerViewModel>(context, listen: false);
        final result = await imageHandler.pickImages();

        if (result['added'] > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Added ${result['added']} image(s). Total: ${result['totalSelected']}/${ImageHandlerViewModel.maxImages}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (result['limitReached']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Image limit reached. You can add up to ${ImageHandlerViewModel.maxImages} images.'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }

      void _confirmRemoveAllImages(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Remove All Images"),
              content:
                  const Text("Are you sure you want to remove all images?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Remove"),
                  onPressed: () {
                    Provider.of<ImageHandlerViewModel>(context, listen: false)
                        .removeAllImages();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
