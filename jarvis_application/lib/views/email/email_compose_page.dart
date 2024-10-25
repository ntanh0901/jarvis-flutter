import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_application/viewmodels/email_compose_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:jarvis_application/services/ai_service.dart';

class EmailComposeScreen extends StatelessWidget {
  const EmailComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailComposeViewModel>(
      builder: (context, emailViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Icon(Icons.arrow_back, color: Color(0xFF1976D2)), // This is equivalent to Colors.blue[700]
                const SizedBox(width: 8),
                const Text('Email reply', style: TextStyle(color: Colors.black)),
                const Spacer(),
                Text('73', style: TextStyle(color: Colors.blue[700])),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: emailViewModel.conversationHistory.length,
                  itemBuilder: (context, index) {
                    final message = emailViewModel.conversationHistory[index];
                    final isUser = message['role'] == 'user';
                    return isUser
                        ? _UserMessage(content: message['content'])
                        : _AIResponse(
                            requestIndex: index,
                          );
                  },
                ),
              ),
              _QuickActionButtons(emailViewModel: emailViewModel),
              _ChatInputWidget(emailViewModel: emailViewModel),
            ],
          ),
        );
      },
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String content;

  const _UserMessage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(content, style: const TextStyle(fontSize: 16)),
    );
  }
}

class _AIResponse extends StatelessWidget {
  final int requestIndex;

  const _AIResponse({
    required this.requestIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailComposeViewModel>(
      builder: (context, emailViewModel, child) {
        final message = emailViewModel.conversationHistory[requestIndex];
        final responses = message['responses'] as List<dynamic>;
        final currentIndex = message['currentResponseIndex'] as int;
        final content = responses[currentIndex] as String;

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jarvis reply', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Divider(),
              _ResponseActions(
                emailViewModel: emailViewModel,
                requestIndex: requestIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponseActions extends StatelessWidget {
  final EmailComposeViewModel emailViewModel;
  final int requestIndex;

  const _ResponseActions({
    required this.emailViewModel,
    required this.requestIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.content_copy, color: Colors.grey),
          onPressed: () {
            Clipboard.setData(ClipboardData(
                text: emailViewModel.conversationHistory[requestIndex]['content']));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response copied to clipboard')));
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.grey),
          onPressed: () => emailViewModel.refreshResponse(requestIndex),
        ),
        IconButton(
          icon: Icon(CupertinoIcons.arrowshape_turn_up_left, 
            color: emailViewModel.canNavigateBack(requestIndex) ? Colors.grey : Colors.grey.withOpacity(0.3)),
          onPressed: emailViewModel.canNavigateBack(requestIndex) 
            ? () => emailViewModel.navigateResponse(requestIndex, false) 
            : null,
        ),
        IconButton(
          icon: Icon(CupertinoIcons.arrowshape_turn_up_right, 
            color: emailViewModel.canNavigateForward(requestIndex) ? Colors.grey : Colors.grey.withOpacity(0.3)),
          onPressed: emailViewModel.canNavigateForward(requestIndex) 
            ? () => emailViewModel.navigateResponse(requestIndex, true) 
            : null,
        ),
      ],
    );
  }
}

class _QuickActionButtons extends StatelessWidget {
  final EmailComposeViewModel emailViewModel;

  const _QuickActionButtons({required this.emailViewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildQuickActionButton('🎉 Thanks', Colors.purple, emailViewModel),
          _buildQuickActionButton('😔 Sorry', Colors.orange, emailViewModel),
          _buildQuickActionButton('👍 Yes', Colors.green, emailViewModel),
          _buildQuickActionButton('👎 No', Colors.red, emailViewModel),
          _buildQuickActionButton('📅 Follow up', Colors.blue, emailViewModel),
          _buildQuickActionButton(
              '🤔 Request for more information', Colors.teal, emailViewModel),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, Color color, EmailComposeViewModel viewModel) {
    return ElevatedButton(
      onPressed: () => viewModel.generateQuickResponse(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _ChatInputWidget extends StatelessWidget {
  final EmailComposeViewModel emailViewModel;

  const _ChatInputWidget({required this.emailViewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: emailViewModel.inputController,
              decoration: InputDecoration(
                hintText: "Tell Jarvis how you want to reply...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue[700]),
            onPressed: () => emailViewModel.sendMessage(),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
