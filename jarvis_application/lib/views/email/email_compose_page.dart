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
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mail_outline,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 8),
                const Text('Email reply',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 4),
                      const Text('73',
                          style: TextStyle(
                              color: Color(0xFF64748b),
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          endDrawer: _buildDrawer(context),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[700]!, Colors.blue[900]!],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/app_circle_icon.png'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Jarvis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Email Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Powered by AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('New Email'),
            onTap: () {
              Navigator.pop(context);
              // Handle new email composition
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.green),
            title: const Text('Email History'),
            onTap: () {
              Navigator.pop(context);
              // Show history of AI-assisted emails
            },
          ),
          ListTile(
            leading: const Icon(Icons.style, color: Colors.orange),
            title: const Text('Writing Styles'),
            onTap: () {
              Navigator.pop(context);
              // Show/edit available writing styles
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.purple),
            title: const Text('Recipient Profiles'),
            onTap: () {
              Navigator.pop(context);
              // Manage recipient profiles for personalized emails
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('AI Settings'),
            onTap: () {
              Navigator.pop(context);
              // Adjust AI behavior and preferences
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.blue),
            title: const Text('Usage Analytics'),
            onTap: () {
              Navigator.pop(context);
              // Show AI usage statistics
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.teal),
            title: const Text('Help & Tutorials'),
            onTap: () {
              Navigator.pop(context);
              // Show help and tutorials for using the AI assistant
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.amber),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pop(context);
              // Allow users to provide feedback on the AI
            },
          ),
        ],
      ),
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
        color: const Color(0xFFF0F5F9), // Updated background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
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
              const Text('Jarvis reply',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF0087DF))),
              const Divider(color: Color(0xFFe4e4e4)),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFe4e4e4)),
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
                text: emailViewModel.conversationHistory[requestIndex]
                    ['content']));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response copied to clipboard')));
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.grey),
          onPressed: () => emailViewModel.refreshResponse(requestIndex),
        ),
        IconButton(
          icon: Icon(CupertinoIcons.arrowshape_turn_up_left_fill,
              color: emailViewModel.canNavigateBack(requestIndex)
                  ? Colors.grey
                  : Colors.grey.withOpacity(0.3)),
          onPressed: emailViewModel.canNavigateBack(requestIndex)
              ? () => emailViewModel.navigateResponse(requestIndex, false)
              : null,
        ),
        IconButton(
          icon: Icon(CupertinoIcons.arrowshape_turn_up_right_fill,
              color: emailViewModel.canNavigateForward(requestIndex)
                  ? Colors.grey
                  : Colors.grey.withOpacity(0.3)),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildQuickActionButton('🙏 Thanks', emailViewModel)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildQuickActionButton('😔 Sorry', emailViewModel)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildQuickActionButton('👍 Yes', emailViewModel)),
              const SizedBox(width: 8),
              Expanded(child: _buildQuickActionButton('👎 No', emailViewModel)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child:
                      _buildQuickActionButton('📅 Follow up', emailViewModel)),
              const SizedBox(width: 8),
              Expanded(
                  flex: 3,
                  child: _buildQuickActionButton(
                      '🤔 Request for more information', emailViewModel)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, EmailComposeViewModel viewModel) {
    return ElevatedButton(
      onPressed: () => viewModel.generateQuickResponse(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF0F5F9),
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: emailViewModel.inputController,
                decoration: InputDecoration(
                  hintText: "Tell Jarvis how you want to reply...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => emailViewModel.sendMessage(),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.send, color: Colors.blue[700], size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
