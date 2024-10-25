import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting DateTime
import 'package:file_picker/file_picker.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  // List of AI Models
  final List<Map<String, dynamic>> aiModels = [
    {"name": "GPT-3.5 Turbo", "icon": 'assets/images/gpt-3.5.png'},
    {"name": "GPT-4 Turbo", "icon": 'assets/images/gpt-4.jpg'},
    {"name": "Claude Instant", "icon": 'assets/images/claude-instant.jpg'},
    {"name": "Claude 3 Sonnet", "icon": 'assets/images/claude-3-sonnet.png'},
    {"name": "Claude 3 Opus", "icon": 'assets/images/claude-3-opus.jpg'},
    {"name": "Gemini Pro", "icon": 'assets/images/gemini.png'}
  ];

  // Change the type of selectedModel
  Map<String, dynamic>? selectedModel;

  // List of Threads
  final List<Thread> threads = [
    Thread(
      title: "Assistance Offered",
      creationTime: DateTime.now().subtract(const Duration(minutes: 28)),
      firstMessage: "Hello! How can I assist you today?",
      source: "en.wikipedia.org",
    ),
    Thread(
      title: "New Flutter Update",
      creationTime: DateTime.now().subtract(const Duration(hours: 1)),
      firstMessage: "Flutter just got a new update. Here are the highlights...",
      source: "flutter.dev",
    ),
    Thread(
      title: "React Native vs Flutter",
      creationTime: DateTime.now().subtract(const Duration(hours: 4)),
      firstMessage: "Which is better, React Native or Flutter? Let's dive in.",
      source: "reactnative.dev",
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedModel = aiModels.isNotEmpty ? aiModels.first : null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes if needed
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    return DateFormat('hh:mm a').format(date);
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildLogo(),
                    const SizedBox(height: 20),
                    _buildGreetingText(),
                    const SizedBox(height: 20),
                    _buildSuggestionButton("Tell me something about the Big Bang..."),
                    _buildSuggestionButton("Please provide 10 gift ideas..."),
                    _buildSuggestionButton("Generate five catchy titles..."),
                  ],
                ),
              ),
            ),
            _buildActionRow(),
            _buildChatInput(),
          ],
        ),
      ),
    );
  }

  // Reusable Logo Widget
  Widget _buildLogo() {
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.purpleAccent.withOpacity(0.1),
        radius: 50,
        child: ClipOval(
          child: Image.asset(
            'assets/images/brain.jpg',
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }

  // Greeting Text Widget
  Widget _buildGreetingText() {
    return const Text(
      "How can I assist you today?",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Suggestion Button Widget
  Widget _buildSuggestionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(text),
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  // Action Row Widget
  Widget _buildActionRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Large screen layout
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildAIModelDropdown(),
                const Spacer(),
                ..._buildIconButtons(),
              ],
            ),
          );
        } else {
          // Small screen layout
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAIModelDropdown(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildIconButtons(),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // AI Model Dropdown Button
  Widget _buildAIModelDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _showModelSelectionDialog(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              selectedModel?['icon'] ?? '',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              selectedModel?['name'] ?? 'Select Model',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  // Icon Buttons Row
  List<Widget> _buildIconButtons() {
    return [
      _buildIconButton(Icons.content_cut),
      _buildIconButton(Icons.add_box_outlined, onPressed: () => _showUploadDialog(context)),
      _buildIconButton(Icons.menu_book_outlined),
      _buildIconButton(Icons.access_time, onPressed: () => _showConversationHistoryDialog(context)),
      _buildIconButton(Icons.add_comment, onPressed: () => _showConversationHistoryDialog(context)),
    ];
  }

  // Reusable Icon Button Widget
  Widget _buildIconButton(IconData icon, {VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed ?? () {},
      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      padding: EdgeInsets.zero,
    );
  }

  // Hàm hiển thị hộp thoại upload PDF
  // Hàm hiển thị hộp thoại upload PDF
  Future<void> _showUploadDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Upload PDF'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn vào nút "X"
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Use Chat with PDF to easily get intelligent summaries and answers for your documents.'),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickPdfFile(context), // Hàm chọn file PDF
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
                      const Icon(Icons.picture_as_pdf, size: 50),
                      const SizedBox(height: 10),
                      const Text('Click or drag and drop here to upload'),
                      const SizedBox(height: 5),
                      Text('File types supported: PDF  |  Max file size: 50MB',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm chọn file PDF
  Future<void> _pickPdfFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Chỉ cho phép chọn file PDF
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Selected PDF: ${file.path}');
      // Đóng hộp thoại sau khi chọn file
      Navigator.of(context).pop();
      // Bạn có thể xử lý file PDF ở đây (upload hoặc đọc file)
    } else {
      // Nếu người dùng hủy chọn file
      print('User canceled the picker.');
    }
  }




  // Chat Input Widget
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Dialog to Select AI Model
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
                          title: Text(
                            model['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
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

// Dialog Header Widget
  Widget _buildDialogHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }




  // Dialog to show conversation history
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
                _buildSearchBarWithIcons(),
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
                            Text(_formatDate(thread.creationTime)),
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



  // Search Bar with Icons Widget
  Widget _buildSearchBarWithIcons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.star_border),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.work_outline),
      ],
    );
  }

  // Circle Icon Button Widget
  Widget _buildCircleIcon(IconData icon) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {},
      ),
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






