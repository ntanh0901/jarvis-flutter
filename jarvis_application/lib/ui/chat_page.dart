import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_application/widgets/chat/greeting_text.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../models/assistant_dto.dart';
import '../models/chat_message.dart';
import '../widgets/chat/action_row.dart';
import '../widgets/chat/ai_model_dropdown.dart';
import '../widgets/chat/conversation_history_dialog.dart';
import '../widgets/chat/image_picker_helper.dart';
import '../widgets/chat/logo_widget.dart';
import '../widgets/chat/upload_dialog.dart';


class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  final FocusNode messageFocusNode = FocusNode();
  String conversationId = '';
  List<ChatMessage> messages = [];

  List<Map<String, dynamic>> items = [
    {
      'title': 'Hi',
      'id': 'f32a6751-9200-4357-9281-d22e5785434c',
      'createdAt': 1730480205,
    },
    {
      'title': 'Hello',
      'id': 'd34b6751-9234-4567-9281-df43c5e5486c',
      'createdAt': 1730470205,
    },
  ];
  String? cursor = 'f32a6751-9200-4357-9281-d22e5785434c'; // Cursor for pagination

  final List<Map<String, dynamic>> aiModels = [
    {
      "id": "GPT_4_O",
      "name": "GPT-4 Turbo",
      "model": "dify",
      "icon": 'assets/images/gpt-4.jpg'
    },
    {
      "id": "CLAUDE_3_HAIKU_20240307",
      "name": "Claude 3 Haiku",
      "model": "dify",
      "icon": 'assets/images/claude-3-sonnet.png'
    },
    // Add more models
  ];

  Map<String, dynamic>? selectedModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedModel = aiModels.isNotEmpty ? aiModels.first : null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageController.dispose();
    messageFocusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  Future<void> _sendMessage(String content) async {
    if (selectedModel == null || content.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        role: 'user',
        content: content,
        assistant: AssistantDto(
          id: selectedModel!['id'],
          model: selectedModel!['model'],
        ),
        files: [],
      ));
    });

    final headers = {
      'Authorization': 'Bearer your_token', // Replace with actual token
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'assistant': {
        'id': selectedModel!['id'],
        'model': selectedModel!['model'],
      },
      'content': content,
      'metadata': {
        'conversation': {
          'id': conversationId.isNotEmpty ? conversationId : null,
          'messages': messages.map((message) => message.toJson()).toList(),
        },
      },
    });

    try {
      final response = await http.post(
        Uri.parse('/api/v1/ai-chat'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          conversationId = responseData['conversationId'];
          messages.add(ChatMessage(
            role: 'model',
            content: responseData['message'],
            assistant: AssistantDto(
              id: selectedModel!['id'],
              model: selectedModel!['model'],
            ),
            files: [],
          ));
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Widget _buildChatInput() {
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside the input
                                        // but it doesn't work =((
    },
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () {
                  ImagePickerHelper.showImagePickerOptions(
                    context,
                    screenshotController: screenshotController,
                  );
                },
              ),
              Expanded(
                child: TextField(
                  focusNode: messageFocusNode, // Attach the focus node
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final text = messageController.text.trim();
                  if (text.isNotEmpty) {
                    _sendMessage(text);
                    messageController.clear();
                    FocusScope.of(context).unfocus(); // Dismiss keyboard after sending
                  }
                },
              ),
            ],
          ),
        ),
    ),
    );
  }


  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'add_comment':
      // Xử lý logic cho "add_comment"
        print("Add comment pressed");
        break;
      case 'upload_pdf':
        _showUploadDialog(context);
        break;
      case 'view_book':
        print("View book pressed");
        break;
      case 'view_history':
        _showConversationHistoryDialog(context);
        break;
      case 'edit_content':
        print("Edit content pressed");
        break;
      default:
        print("Unknown action: $action");
    }
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return UploadDialog(
          onFilePicked: (file) {
            if (file != null) {
              print('Selected file: ${file.path}');

              // Xử lý file tải lên
            }
          },
        );
      },
    );
  }

  void _showConversationHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ConversationHistoryDialog(
          initialItems: items, // Truyền danh sách items
          cursor: cursor, // Truyền cursor cho dialog
          onItemsUpdated: (updatedItems) {
            setState(() {
              items = updatedItems; // Cập nhật danh sách khi xóa
            });
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/publishing-platforms');
              },
              child: const Text(
                'Publish',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              LogoWidget(),
              const SizedBox(height: 10),
              GreetingText(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message.role == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.role == 'user'
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.content),
                      ),
                    );
                  },
                ),
              ),
              ActionRow(
                aiModels: aiModels,
                selectedModel: selectedModel,
                onModelSelected: (model) {
                  setState(() {
                    selectedModel = model;
                  });
                },
                onActionSelected: (action) {
                  _handleAction(action, context);
                },
              ),
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }
}




