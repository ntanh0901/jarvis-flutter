import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:jarvis_application/styles/chat_screen_styles.dart';
import 'package:screenshot/screenshot.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  int _selectedIconIndex = -1;
  late ScreenshotController screenshotController;

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
    screenshotController = ScreenshotController();
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
                      _buildSuggestionButton(
                          "Tell me something about the Big Bang..."),
                      _buildSuggestionButton("Please provide 10 gift ideas..."),
                      _buildSuggestionButton("Generate five catchy titles..."),
                    ],
                  ),
                ),
              ),
              _buildSelectedImages(),
              _buildActionRow(),
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildGreetingText() {
    return const Text(
      "How can I assist you today?",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSuggestionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {
          // Handle suggestion button tap
        },
        child: Text(text),
      ),
    );
  }

Widget _buildActionRow() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildAIModelDropdown(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildIconButtons(),
          ),
        ),
      ],
    );
  }

Widget _buildAIModelDropdown() {
    return Align(
      alignment: Alignment
          .centerLeft, // Ensures the dropdown floats to the left of the parent
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => _showModelSelectionDialog(context),
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Ensures dropdown only takes the necessary width
            children: [
              if (selectedModel?['icon'] != null)
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
      ),
    );
  }

  
  List<Widget> _buildIconButtons() {
    List<IconData> icons = [
      Icons.content_cut,
      Icons.add_box_outlined,
      Icons.menu_book_outlined,
      Icons.access_time,
      Icons.add_comment,
    ];

    return List.generate(icons.length, (index) {
      return _buildIconButton(
        icons[index],
        index: index,
        onPressed: () {
          setState(() {
            _selectedIconIndex = index;
          });
          if (index == 1) _showUploadDialog(context);
          if (index == 3 || index == 4) _showConversationHistoryDialog(context);
        },
      );
    });
  }

  Widget _buildIconButton(IconData icon,
      {required int index, required VoidCallback onPressed}) {
    bool isSelected = index == _selectedIconIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[600],
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

Widget _buildChatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: ChatScreenStyles.iconColor),
            onPressed: () => _showImagePickerOptions(context),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: ChatScreenStyles.iconColor),
            onPressed: () {
              // Handle send message
            },
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .pickImages(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .takePhoto(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.screenshot),
                title: const Text('Take a screenshot'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .takeScreenshot(screenshotController),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImageOptionTap(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    final imageHandler =
        Provider.of<ImageHandlerViewModel>(context, listen: false);

    if (!imageHandler.canAddMoreImages) {
      _showImageAddedFeedback(context, {
        'added': 0,
        'totalSelected': imageHandler.selectedImageCount,
        'limitReached': true
      });
      return;
    }

    final result = await action();

    if (context.mounted) {
      if (result['error'] != null) {
        _showErrorFlushbar(context, result['error']);
      } else {
        _showImageAddedFeedback(context, result);
      }
    }
  }

  void _showErrorFlushbar(BuildContext context, String errorMessage) {
    ChatScreenStyles.createCenteredFlushbar(
      message: errorMessage,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: Icons.error_outline,
    ).show(context);
  }

  void _showImageAddedFeedback(
      BuildContext context, Map<String, dynamic> result) {
    String message;
    IconData icon;
    Color backgroundColor;

    if (result['added'] > 0) {
      message =
          'Added ${result['added']} image(s). Total: ${result['totalSelected']}/${ImageHandlerViewModel.maxImages}';
      icon = Icons.check_circle_outline;
      backgroundColor = Colors.green;
    } else if (result['limitReached']) {
      message =
          'Max image limit reached (${result['totalSelected']}/${ImageHandlerViewModel.maxImages})';
      icon = Icons.warning_amber_rounded;
      backgroundColor = Theme.of(context).colorScheme.error;
    } else {
      message = 'No images added';
      icon = Icons.info_outline;
      backgroundColor = Colors.blue;
    }

    ChatScreenStyles.createCenteredFlushbar(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
    ).show(context);
  }

  Widget _buildSelectedImages() {
    return Consumer<ImageHandlerViewModel>(
      builder: (context, imageHandler, child) {
        if (imageHandler.selectedImages.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildSelectedImagesPreview(imageHandler, context);
      },
    );
  }

  Widget _buildSelectedImagesPreview(
      ImageHandlerViewModel imageHandler, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageHandler.selectedImages.length,
                itemBuilder: (context, idx) =>
                    _buildImagePreviewItem(imageHandler, idx, context),
              ),
            ),
          ),
          Tooltip(
            message: 'Remove All Images',
            child: IconButton(
              icon: const Icon(Icons.delete_sweep,
                  color: ChatScreenStyles.iconColor),
              onPressed: () => _confirmRemoveAllImages(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewItem(
      ImageHandlerViewModel imageHandler, int idx, BuildContext context) {
    Uint8List imageData = imageHandler.selectedImages[idx];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              imageData,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => imageHandler.removeImageAt(idx),
            child: Container(
              decoration: ChatScreenStyles.removeImageButtonDecoration(context),
              child: const Icon(
                Icons.close,
                size: 14,
                color: ChatScreenStyles.removeImageButtonIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmRemoveAllImages(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove All Images"),
          content: const Text("Are you sure you want to remove all images?"),
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
                context.read<ImageHandlerViewModel>().removeAllImages();
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ChatScreenStyles.createCenteredFlushbar(
                      message: 'All images removed',
                      backgroundColor: Colors.green,
                      icon: Icons.delete_sweep,
                    ).show(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showModelSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select AI Model'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: aiModels.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.asset(
                    aiModels[index]['icon'],
                    width: 24,
                    height: 24,
                  ),
                  title: Text(aiModels[index]['name']),
                  onTap: () {
                    setState(() {
                      selectedModel = aiModels[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showUploadDialog(BuildContext context) {
    // Implement upload dialog
  }

  void _showConversationHistoryDialog(BuildContext context) {
    // Implement conversation history dialog
  }
}

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
