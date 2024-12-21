import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jarvis_application/core/constants/api_endpoints.dart';
import 'package:jarvis_application/widgets/chat/greeting_text.dart';
import 'package:screenshot/screenshot.dart';

import '../../../data/models/ai_chat_metadata.dart';
import '../../../data/models/assistant.dart';
import '../../../data/models/assistant_dto.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/conversation_history_res.dart';
import '../../../data/models/conversations_query_params.dart';
import '../../../data/models/conversations_res.dart';
import '../../../data/models/request_ai_chat.dart';
import '../../../providers/dio_provider.dart';
import '../../../widgets/chat/action_row.dart';
import '../../../widgets/chat/conversation_history_dialog.dart';
import '../../../widgets/chat/image_picker_helper.dart';
import '../../../widgets/chat/logo_widget.dart';
import '../../../widgets/chat/upload_dialog.dart';
import '../../widgets/app_drawer.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const String routeName = '/chat';

  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();

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

  late Dio _dio;

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
    _dio = ref.read(dioProvider);
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

    // Reduce Token for each message
    content = cleanContent(content);

    try {
      Response response;

      // Set up the request data
      if (metadata.conversation.id == "") {
        // First-time request
        final requestBody = requestAiChat
          ..setContent(content)
          ..setAssistant(currAssistant.dto);

        response = await _dio.post(
          '/api/v1/ai-chat',
          data: requestBody.toJsonFirstTime(),
        );

        print("Meta Req First Time: ${metadata.toJson()}");
      } else {
        // Subsequent messages
        final requestBody = requestAiChat
          ..setContent(content)
          ..setAssistant(currAssistant.dto)
          ..setMetadata(metadata);

        response = await _dio.post(
          '/api/v1/ai-chat/messages',
          data: requestBody.toJson(),
          options: Options(headers: {'x-jarvis-guid': ''}),
        );

        print("Meta Req Next Time: ${metadata.toJson()}");
      }

      // Handle response
      if (response.statusCode == 200) {
        final responseAIChat = response.data;

        conversationID = responseAIChat['conversationId'];
        final messageAI = responseAIChat['message'];
        final remainingUsage = responseAIChat['remainingUsage'];

        messages.add(ChatMessage(
          assistant: currAssistant.dto,
          role: 'model',
          content: messageAI,
        ));

        setState(() {
          remainUsage = remainingUsage;
        });
        _scrollToBottom();

        currentMessageUser.setValues(
          newRole: 'user',
          newContent: content,
          newAssistant: currAssistant.dto,
        );

        currentMessageAI.setValues(
          newRole: 'model',
          newContent: messageAI,
          newAssistant: currAssistant.dto,
        );
        metadata.setConversationID(conversationID);
        metadata.addMessage(currentMessageUser);
        metadata.addMessage(currentMessageAI);

        print("Meta Result: ${metadata.toJson()}");
      } else {
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.statusMessage}";
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
    // Create query parameters
    ConversationsQueryParams queryParams = ConversationsQueryParams(
      cursor: '',
      limit: 100,
      assistantId: selectedAssistant?.dto.id,
      assistantModel: selectedAssistant?.dto.model,
    );

    try {
      // Build request URL
      final queryParameters = {
        'assistantId': idValues.reverse[queryParams.assistantId],
        'assistantModel': 'dify',
      };

      // Get Dio instance

      // Send request
      final response = await _dio.get(
        ApiEndpoints.getConversations,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        // Parse response
        var responseData = response.data;

        ConversationsRes conversations =
            ConversationsRes.fromJson(responseData);

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
            "Request failed with status: ${response.statusCode}\nReason: ${response.statusMessage}";
        _showErrorDialog(context, "Error", errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "An error occurred: $e");
    }
  }

  Future<void> _fetchConversationHistory(String newConversationID) async {
    // Create query parameters
    ConversationsQueryParams queryParams = ConversationsQueryParams(
      cursor: '',
      limit: 100,
      assistantId: selectedAssistant?.dto.id,
      assistantModel: selectedAssistant?.dto.model,
    );

    try {
      // Build request URL
      final queryParameters = {
        'assistantId': idValues.reverse[queryParams.assistantId],
        'assistantModel': 'dify',
      };

      final newConversationUrl =
          '/api/v1/ai-chat/conversations/$newConversationID/messages';

      // Send request
      final response = await _dio.get(
        newConversationUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        // Parse response
        var responseData = response.data;
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
      } else {
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.statusMessage}";
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
            .unfocus(); // Dismiss keyboard when tapping outside
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextField(
            maxLines: 5,
            minLines: 1,
            focusNode: messageFocusNode,
            controller: messageController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () {
                  ImagePickerHelper.showImagePickerOptions(
                    context,
                    screenshotController: screenshotController,
                  );
                },
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final text = messageController.text.trim();
                  if (text.isNotEmpty) {
                    _sendMessage(text, selectedAssistant!);
                    messageController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Ask me anything, press \'/\' for prompts...',
              hintStyle: const TextStyle(
                color: Color(0xFFB9B9B9),
              ),
              isDense: true, // Reduces height slightly
            ),
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
        _fetchConversationHistory(conversationID);
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
    return SafeArea(
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 20,
              title: const Text(
                'Chat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              backgroundColor: Colors.white,
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
              )),
          drawer: const AppDrawer(),
          body: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      LogoWidget(),
                      SizedBox(height: 10),
                      GreetingText(),
                      SizedBox(height: 10),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isTyping) {
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
                            left: 30, right: 10, top: 10, bottom: 5)
                            : const EdgeInsets.only(
                            left: 10, right: 30, top: 20, bottom: 5),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: message.role == 'user'
                              ? const Color(0xFF6841EA)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                message.role == 'user' ? 20 : 0),
                            topRight: Radius.circular(
                                message.role == 'user' ? 0 : 20),
                            bottomLeft: const Radius.circular(20),
                            bottomRight: const Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Flexible(
                          child: MarkdownBody(
                            data: message.content!,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: message.role == 'user'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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
