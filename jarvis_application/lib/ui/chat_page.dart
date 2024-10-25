// lib/chat_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/chat_input_widget.dart';
import '../widgets/greeting_text_widget.dart';
import '../widgets/logo_widget.dart';
import '../widgets/suggestion_button_widget.dart';



class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> aiModels = [
    {"name": "GPT-3.5 Turbo", "icon": 'assets/images/gpt-3.5.png'},
    {"name": "GPT-4 Turbo", "icon": 'assets/images/gpt-4.jpg'},
    {"name": "Claude Instant", "icon": 'assets/images/claude-instant.jpg'},
    {"name": "Claude 3 Sonnet", "icon": 'assets/images/claude-3-sonnet.png'},
    {"name": "Claude 3 Opus", "icon": 'assets/images/claude-3-opus.jpg'},
    {"name": "Gemini Pro", "icon": 'assets/images/gemini.png'}
  ];

  Map<String, dynamic>? selectedModel;
  final List<Thread> threads = [
    Thread(
      title: "Assistance Offered",
      creationTime: DateTime.now().subtract(Duration(minutes: 28)),
      firstMessage: "Hello! How can I assist you today?",
      source: "en.wikipedia.org",
    ),
    Thread(
      title: "New Flutter Update",
      creationTime: DateTime.now().subtract(Duration(hours: 1)),
      firstMessage: "Flutter just got a new update. Here are the highlights...",
      source: "flutter.dev",
    ),
    Thread(
      title: "React Native vs Flutter",
      creationTime: DateTime.now().subtract(Duration(hours: 4)),
      firstMessage: "Which is better, React Native or Flutter? Let's dive in.",
      source: "reactnative.dev",
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedModel = aiModels.isNotEmpty ? aiModels.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          LogoWidget(),
          const SizedBox(height: 20),
          GreetingTextWidget(),
          const SizedBox(height: 20),
          SuggestionButtonWidget(text: "Tell me something about the Big Bang..."),
          SuggestionButtonWidget(text: "Please provide 10 gift ideas..."),
          SuggestionButtonWidget(text: "Generate five catchy titles..."),
          const Spacer(),
          _buildActionRow(),
          ChatInputWidget(onSend: () => print("Message sent")),
        ],
      ),
    );
  }

  // Action Row Widget
  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: _buildAIModelDropdown(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconButton(Icons.content_cut),
                _buildIconButton(Icons.add_box_outlined, onPressed: () => _showUploadDialog(context)),
                _buildIconButton(Icons.menu_book_outlined),
                _buildIconButton(Icons.access_time, onPressed: () => _showConversationHistoryDialog(context)),
                _buildIconButton(Icons.add_comment, onPressed: () => _showConversationHistoryDialog(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIModelDropdown() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      icon: Image.asset(
        selectedModel?['icon'] ?? 'assets/images/default_icon.png',
        width: 18,
        height: 18,
        fit: BoxFit.cover,
      ),
      label: Text(
        selectedModel?['name'] ?? "Select Model",
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      onPressed: () => _showModelSelectionDialog(context),
    );
  }

  Widget _buildIconButton(IconData icon, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 18,
        onPressed: onPressed ?? () {},
      ),
    );
  }

  Future<void> _showUploadDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upload PDF'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: GestureDetector(
            onTap: () => _pickPdfFile(context),
            child: Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 50),
                  SizedBox(height: 10),
                  Text('Click or drag and drop here to upload'),
                  SizedBox(height: 5),
                  Text('File types supported: PDF | Max file size: 50MB',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPdfFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Selected PDF: ${file.path}');
      Navigator.of(context).pop();
    } else {
      print('User canceled the picker.');
    }
  }

  void _showModelSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader('Select AI Model'),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: aiModels.length,
                    itemBuilder: (context, index) {
                      final model = aiModels[index];
                      final bool isSelected = model == selectedModel;

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purpleAccent.withOpacity(0.1),
                            child: Image.asset(
                              model['icon'],
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          title: Text(model['name']),
                          trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                          onTap: () {
                            setState(() {
                              selectedModel = model;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  void _showConversationHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader('Conversation History'),
                Expanded(
                  child: ListView.builder(
                    itemCount: threads.length,
                    itemBuilder: (context, index) {
                      final thread = threads[index];
                      return ListTile(
                        title: Text(thread.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('hh:mm a').format(thread.creationTime)),
                            Text(thread.firstMessage),
                            Text(thread.source, style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Thread class to store thread information
class Thread {
  final String title;
  final DateTime creationTime;
  final String firstMessage;
  final String source;

  Thread({
    required this.title,
    required this.creationTime,
    required this.firstMessage,
    required this.source,
  });
}
