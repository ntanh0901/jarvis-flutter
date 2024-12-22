import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_application/ui/views/aiBots/publish_page.dart';
import '../../../data/models/bot/ai_assistant.dart';
import '../../../data/models/bot/chat_bot/message.dart';
import '../../../providers/ai_bot_provider.dart';
import '../../../widgets/chat/greeting_text.dart';
import '../../../widgets/chat/logo_widget.dart';

class BotChatPage extends ConsumerStatefulWidget {
  static const String routeName = '/bot-chat';

  final AIAssistant currentAssistant;
  final String openAiThreadId;

  const BotChatPage({
    super.key,
    required this.currentAssistant,
    required this.openAiThreadId,
  });

  @override
  ConsumerState<BotChatPage> createState() => _BotChatPageState();
}

class _BotChatPageState extends ConsumerState<BotChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> messages = [];
  bool isTyping = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedMessages = await ref
          .read(aiAssistantProvider.notifier)
          .fetchMessagesByThreadId(widget.openAiThreadId);

      setState(() {
        messages = fetchedMessages.reversed.toList();
      });

      // Cuộn xuống sau khi danh sách tin nhắn được tải xong
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    setState(() {
      isTyping = true;
      messages.add(Message(
        role: 'user',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        content: [
          Content(
            type: 'text',
            text: TextContent(value: content, annotations: []),
          )
        ],
      ));
    });

    // scroll to bottom when user sends a message
    _scrollToBottom();

    final response =
        await ref.read(aiAssistantProvider.notifier).sendMessageToAssistant(
              widget.currentAssistant.id,
              content,
              widget.openAiThreadId,
            );

    setState(() {
      messages.add(Message(
        role: 'assistant',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        content: [
          Content(
            type: 'text',
            text: TextContent(value: response, annotations: []),
          )
        ],
      ));
      isTyping = false;
    });

    _scrollToBottom();
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


  Future<void> _linkKnowledge(String knowledgeId) async {
    try {
      await ref.read(aiAssistantProvider.notifier).addKnowledgeToAssistant(
        assistantId: widget.currentAssistant.id,
        knowledgeId: knowledgeId,
      );

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Knowledge $knowledgeId linked successfully.')),
      );
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to link knowledge: $e')),
      );
    }
  }

  // IconButton(
  // icon: const Icon(Icons.link, color: Colors.blue),
  // onPressed: () {
  // _linkKnowledge('your-knowledge-id');
  // },
  // ),



  Widget _buildChatInput() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
            controller: messageController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () {},
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final text = messageController.text.trim();
                  if (text.isNotEmpty) {
                    _sendMessage(text);
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
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bot Assistant"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishingPlatformPage(
                    currentAssistant: widget.currentAssistant,
                  ),
                ),
              );
            },
            child: const Text(
              'Publish',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),


        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const LogoWidget(imageType: 2),
                            const SizedBox(height: 10),
                            GreetingText(
                                assistantName:
                                    widget.currentAssistant.assistantName),
                            const SizedBox(height: 10),
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
                          final isUser = message.role == 'user';
                          final content = message.content.first.text.value;

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: isUser
                                  ? const EdgeInsets.only(
                                      left: 30, right: 10, top: 10, bottom: 5)
                                  : const EdgeInsets.only(
                                      left: 10, right: 30, top: 20, bottom: 5),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFF6841EA)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isUser ? 20 : 0),
                                  topRight: Radius.circular(isUser ? 0 : 20),
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
                              child: MarkdownBody(
                                data: content,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: isUser ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }
}
