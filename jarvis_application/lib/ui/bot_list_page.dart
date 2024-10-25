import 'dart:io'; // Để xử lý File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:provider/provider.dart';
import 'package:jarvis_application/providers/ai_bot_provider.dart';
import 'package:intl/intl.dart';

class BotListPage extends StatelessWidget {
  static const String routeName = '/bot-list';

  const BotListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bot List'),
      ),
      body: Consumer<AIBotProvider>(
        builder: (context, botProvider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Large screen layout
                return _buildLargeScreenLayout(botProvider);
              } else {
                // Small screen layout
                return _buildSmallScreenLayout(botProvider);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateBotDialog(context); // Hiển thị form tạo bot khi nhấn nút
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLargeScreenLayout(AIBotProvider botProvider) {
    return ListView.builder(
      itemCount: botProvider.aiBots.length,
      itemBuilder: (context, index) {
        final bot = botProvider.aiBots[index];
        String formattedDate = DateFormat('MM/dd/yyyy').format(bot.createdAt);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(bot.imageUrl),
            radius: 25,
          ),
          title: Text(
            bot.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bot.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.star_border, color: Colors.grey),
                onPressed: () {
                  // Handle favorite action
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  botProvider.deleteAIBot(bot.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSmallScreenLayout(AIBotProvider botProvider) {
    return ListView.builder(
      itemCount: botProvider.aiBots.length,
      itemBuilder: (context, index) {
        final bot = botProvider.aiBots[index];
        String formattedDate = DateFormat('MM/dd/yyyy').format(bot.createdAt);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(bot.imageUrl),
                        radius: 25,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bot.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star_border, color: Colors.grey, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              // Handle favorite action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              botProvider.deleteAIBot(bot.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    bot.description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Hàm hiển thị form để tạo bot mới
  void _showCreateBotDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    File? imageFile; // Biến lưu trữ ảnh đã chọn
    final ImagePicker picker = ImagePicker(); // Tạo instance của ImagePicker

    Future<void> pickImage() async {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path); // Lưu trữ đường dẫn ảnh
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Assistant'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bot name input
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Bot Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Bot description input
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Bot Description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // Image upload
                    const Text('Profile picture'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        await pickImage(); // Gọi hàm chọn ảnh
                        setState(() {}); // Cập nhật giao diện sau khi chọn ảnh
                      },
                      child: imageFile != null
                          ? Image.file(imageFile!, width: 100, height: 100) // Hiển thị ảnh đã chọn
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      Provider.of<AIBotProvider>(context, listen: false).createAIBot(
                        nameController.text,
                        descriptionController.text,
                        imageFile?.path ?? '', // Đường dẫn ảnh hoặc rỗng nếu chưa có ảnh
                      );
                      Navigator.of(context).pop(); // Đóng dialog sau khi tạo bot
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
