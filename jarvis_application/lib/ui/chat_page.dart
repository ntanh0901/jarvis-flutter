import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_application/widgets/chat/greeting_text.dart';
import 'package:screenshot/screenshot.dart';

import '../data/models/ai_chat_metadata.dart';
import '../data/models/assistant.dart';
import '../data/models/assistant_dto.dart';
import '../data/models/chat_message.dart';
import '../data/models/conversation_history_res.dart';
import '../data/models/conversations_query_params.dart';
import '../data/models/conversations_res.dart';
import '../data/models/request_ai_chat.dart';
import '../widgets/chat/action_row.dart';
import '../widgets/chat/conversation_history_dialog.dart';
import '../widgets/chat/image_picker_helper.dart';
import '../widgets/chat/logo_widget.dart';
import '../widgets/chat/upload_dialog.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjRjMjI5ZTQwLTIzYWQtNGVmYy1hMWEzLTZhYTBhNWU5MWNhZCIsImVtYWlsIjoicXVhbmd0aGllbjEyMzRAZ21haWwuY29tIiwiaWF0IjoxNzMyMzgzMjg4LCJleHAiOjE3NjM5MTkyODh9.XOW7jVor7eSnViQmwlfwAUHWgiQ_QIzAcpCrcBCUT6E';

  final FocusNode messageFocusNode = FocusNode();
  final metadata = AiChatMetadata.empty();
  late int remainUsage;

  late ChatMessage currentMessageUser;
  late ChatMessage currentMessageAI;

  late RequestAiChat requestAiChat;
  bool isTyping = false;
  String conversationID = '';

  final idValues = EnumValues({
    "claude-3-haiku-20240307": Id.CLAUDE_3_HAIKU_20240307,
    "claude-3-sonnet-20240229": Id.CLAUDE_3_SONNET_20240229,
    "gemini-1.5-flash-latest": Id.GEMINI_15_FLASH_LATEST,
    "gemini-1.5-pro-latest": Id.GEMINI_15_PRO_LATEST,
    "gpt-4o": Id.GPT_4_O,
    "gpt-4o-mini": Id.GPT_4_O_MINI
  });

  List<Map<String, dynamic>> items = [];
  final List<ChatMessage> messages = [];

  String? cursor =
      'f32a6751-9200-4357-9281-d22e5785434c'; // Cursor for pagination

  Assistant? selectedAssistant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedAssistant = assistants.isNotEmpty ? assistants.first : null;
    // initial Message  = empty
    currentMessageUser = ChatMessage.empty();
    currentMessageAI = ChatMessage.empty();
    remainUsage = 0;
    requestAiChat = RequestAiChat(
      assistant: selectedAssistant!.dto,
      content: '',
      metadata: metadata,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    messageController.dispose();
    messageFocusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  Future<void> _sendMessage(String content, Assistant currAssistant) async {
    // Add message to the local list
    messages.add(ChatMessage(
      assistant: currAssistant.dto,
      role: 'user',
      content: content,
    ));
    setState(() {
      isTyping = true;
    });

    // reduce Token for each message
    content = cleanContent(content);

    // print("Request Body Before Sendingssssss: ${jsonEncode(requestAiChat.toJson())}");

    // Setup headers and URL
    var headers = {
      'x-jarvis-guid': '',
      'Authorization':
          'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Send request to the API
    try {
      Uri url;
      http.Request request;

      // For first time
      if (metadata.conversation.id == "") {
        url = Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat');
        request = http.Request('POST', url);
        requestAiChat.setContent(content);
        requestAiChat.setAssistant(currAssistant.dto);
        request.body = jsonEncode(requestAiChat.toJsonFirstTime());
        print("Meta Req First Timeeeeeee: ${jsonEncode(metadata.toJson())}");
      }
      // For next messages
      else {
        url = Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat/messages');
        request = http.Request('POST', url);

        requestAiChat.setContent(content);
        requestAiChat.setAssistant(currAssistant.dto);
        requestAiChat.setMetadata(metadata);
        print("Meta Req Next Timeeeeeee: ${jsonEncode(metadata.toJson())}");

        request.body = jsonEncode(requestAiChat.toJson());
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // Read response
      if (response.statusCode == 200) {
        String responseJson = await response.stream.bytesToString();
        Map<String, dynamic> responseAIChat = jsonDecode(responseJson);

        // Extract values from the response
        conversationID = responseAIChat['conversationId'];
        String messageAI = responseAIChat['message'];
        int remainingUsage = responseAIChat['remainingUsage'];
        // print("requestttttttt111111111111111: ${jsonEncode(requestAiChat.toJson())}");
        // print("Response JSON: $responseJson");

        messages.add(ChatMessage(
          assistant: currAssistant.dto,
          role: 'model',
          content: messageAI,
        ));

        setState(() {
          remainUsage = remainingUsage;
        }); // Đảm bảo UI được cập nhật
        _scrollToBottom();

        currentMessageUser.setValues(
            newRole: 'user',
            newContent: content,
            newAssistant: currAssistant.dto);

        currentMessageAI.setValues(
            newRole: 'model',
            newContent: messageAI,
            newAssistant: currAssistant.dto);
        metadata.setConversationID(conversationID);
        metadata.addMessage(currentMessageUser);
        metadata.addMessage(currentMessageAI);
        print("Meta Resultttttttttt: ${jsonEncode(metadata.toJson())}");

        // Optionally update local state or UI
      } else {
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.reasonPhrase}";
        _showErrorDialog(context, "Error", errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "An error occurred: $e");
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

  String cleanContent(String content) {
    content =
        content.length > 100 ? '${content.substring(0, 100)}...' : content;
    return content.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> _fetchConversations() async {
    // Setup headers
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Create query parameters
    ConversationsQueryParams queryParams = ConversationsQueryParams(
      cursor: '',
      limit: 100,
      assistantId: selectedAssistant?.dto.id,
      assistantModel: selectedAssistant?.dto.model,
    );

    try {
      // Build request URL
      //var url = Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-chat/conversations');
      var url = Uri.https(
        'api.dev.jarvis.cx',
        '/api/v1/ai-chat/conversations', // Đường dẫn không chứa query string
        {
          'assistantId': idValues.reverse[queryParams.assistantId],
          'assistantModel': 'dify',
        },
      );

      // print(url.toString());
      // print("URLLLLLLLLL: ${url}");

      // Send request
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse response
        var responseData = jsonDecode(response.body);
        // print(responseData['items']);
        // print("successsssssssssssssssssssssssssssssssssssssssssss data: $responseData");

        ConversationsRes conversations =
            ConversationsRes.fromJson(responseData);
        // print("Response Dataaaaaaaaaaaaaaaa: $conversations");

        setState(() {
          items = List<Map<String, dynamic>>.from(
            conversations.items.map((item) => {
                  'title': item.title ?? '',
                  'id': item.id ?? '',
                  'createdAt': item.createdAt ?? 0,
                }),
          );
          cursor = conversations.cursor;
        });
      } else {
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.reasonPhrase}";
        _showErrorDialog(context, "Error", errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "An error occurred: $e");
    }
  }

  Future<void> _fetchConversationHistory(String newConversationID) async {
    // Setup headers
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Create query parameters
    ConversationsQueryParams queryParams = ConversationsQueryParams(
      cursor: '',
      limit: 100,
      assistantId: selectedAssistant?.dto.id,
      assistantModel: selectedAssistant?.dto.model,
    );

    try {
      // Build request URL
      var url = Uri.https(
        'api.dev.jarvis.cx',
        '/api/v1/ai-chat/conversations/$newConversationID/messages',
        // Đường dẫn không chứa query string
        {
          'assistantId': idValues.reverse[queryParams.assistantId],
          'assistantModel': 'dify',
        },
      );

      // print("URLLLLLLLLL: ${url}");

      // Send request
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse response
        var responseData = jsonDecode(response.body);
        // print(responseData['items']);
        print(
            "successsssssssssssssssssssssssssssssssssssssssssss data: $responseData");

        ConversationHistoryRes conversationHistory =
            ConversationHistoryRes.fromJson(responseData);
        print("Historyyyyyyyyyyyyyy: $conversationHistory");

        setState(() {
          cursor = conversationHistory.cursor;
          messages.clear();
          for (var i in conversationHistory.items!) {
            messages.add(ChatMessage(
              assistant: selectedAssistant?.dto,
              role: 'user',
              content: i.query,
            ));
            messages.add(ChatMessage(
              assistant: selectedAssistant?.dto,
              role: 'model',
              content: i.answer,
            ));
            currentMessageUser.setValues(
                newRole: 'user',
                newContent: i.query,
                newAssistant: selectedAssistant?.dto);

            currentMessageAI.setValues(
                newRole: 'model',
                newContent: i.answer,
                newAssistant: selectedAssistant?.dto);

            metadata.setConversationID(conversationID);
            metadata.addMessage(currentMessageUser);
            metadata.addMessage(currentMessageAI);
            conversationID = newConversationID;
            print("Meta Historyyyyyyyy: ${jsonEncode(metadata.toJson())}");
          }
        });

        // metadata.conversation.id= newConversationID;
        // metadata.conversation.messages = messages;
      } else {
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.reasonPhrase}";
        _showErrorDialog(context, "Error", errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "An error occurred: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildChatInput() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss keyboard when tapping outside the input
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
                    _sendMessage(text, selectedAssistant!);
                    messageController.clear();
                    FocusScope.of(context)
                        .unfocus(); // Dismiss keyboard after sending
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetConversation() async {
    setState(() {
      messages.clear();
      remainUsage = 0;
    });

    await Future.delayed(const Duration(milliseconds: 200));

    // Reset các giá trị khác
    metadata.conversation.id = "";
    metadata.conversation.messages.clear();
    conversationID = "";
    currentMessageUser = ChatMessage.empty();
    currentMessageAI = ChatMessage.empty();

    requestAiChat = RequestAiChat(
      assistant: selectedAssistant!.dto,
      content: '',
      metadata: metadata,
    );

    print("Conversation reset successfully.");
  }

  Future<void> _handleAction(String action, BuildContext context) async {
    switch (action) {
      case 'add_comment':
        await resetConversation();
        break;
      case 'upload_pdf':
        _showUploadDialog(context);
        break;
      case 'view_book':
        _fetchConversationHistory('9117d62c-e295-443b-8259-e3609ca3f74f');
        break;
      case 'view_history':
        _showConversationHistoryDialog(context);
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

  void _showConversationHistoryDialog(BuildContext context) async {
    // fetch conversations
    await _fetchConversations();

    showDialog(
      context: context,
      builder: (context) {
        return ConversationHistoryDialog(
          initialItems: items,
          cursor: cursor,
          onItemsUpdated: (updatedItems) {
            setState(() {
              items = updatedItems; // Update the local list
            });
          },
          onItemSelected: (conversationID) {
            _fetchConversationHistory(conversationID);
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
              const LogoWidget(),
              const SizedBox(height: 10),
              const GreetingText(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isTyping) {
                      // Hiển thị hiệu ứng "jumping dots" khi đang chờ phản hồi
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SpinKitThreeBounce(
                            color: Colors.grey,
                            size: 20.0,
                          ),
                        ),
                      );
                    }

                    final message = messages[index];
                    return Align(
                      alignment: message.role == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: message.role == 'user'
                            ? const EdgeInsets.only(
                                left: 50, right: 10, top: 5, bottom: 5)
                            : const EdgeInsets.only(
                                left: 10, right: 50, top: 5, bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.role == 'user'
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.content!),
                      ),
                    );
                  },
                ),
              ),
              ActionRow(
                assistants: assistants,
                selectedAssistant: selectedAssistant,
                onAssistantSelected: (assistant) {
                  setState(() {
                    selectedAssistant = assistant;
                  });
                },
                onActionSelected: (action) {
                  _handleAction(action, context);
                },
                remainUsage: remainUsage,
              ),
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }
}
