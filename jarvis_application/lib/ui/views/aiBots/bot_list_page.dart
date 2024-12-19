import 'dart:io'; // Để xử lý File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:intl/intl.dart';
import 'package:jarvis_application/providers/ai_bot_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_drawer.dart';

class BotListPage extends StatefulWidget {
  static const String routeName = '/bot-list';

  const BotListPage({super.key});

  @override
  _BotListPageState createState() => _BotListPageState();
}

class _BotListPageState extends State<BotListPage> {
  String _searchQuery = ''; // Biến lưu trữ giá trị tìm kiếm

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('AI Bots'),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search AI Bots',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery =
                        query; // Cập nhật giá trị tìm kiếm khi người dùng nhập
                  });
                },
              ),
            ),
            Expanded(
              child: Consumer<AIBotProvider>(
                builder: (context, botProvider, child) {
                  // Lọc danh sách bot dựa trên giá trị tìm kiếm
                  final filteredBots = botProvider.aiBots
                      .where((bot) => bot.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredBots.length,
                    itemBuilder: (context, index) {
                      final bot = filteredBots[index];
                      String formattedDate =
                          DateFormat('MM/dd/yyyy').format(bot.createdAt);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(bot.imageUrl),
                              radius: 20, // Adjust the size of the avatar
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bot.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow
                                            .visible, // Ensures all content is shown
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bot.description,
                                        style: const TextStyle(
                                            color: Colors
                                                .black54), // Optional styling
                                        overflow: TextOverflow.visible,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  splashRadius: 16.0,
                                  icon: const Icon(Icons.star_border,
                                      color: Colors.grey, size: 20),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  splashRadius: 16.0,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () {
                                    botProvider.deleteAIBot(bot.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateBotDialog(context); // Hiển thị form tạo bot khi nhấn nút
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Hàm hiển thị form để tạo bot mới
  void _showCreateBotDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    File? imageFile; // Biến lưu trữ ảnh đã chọn
    final ImagePicker picker = ImagePicker(); // Tạo instance của ImagePicker

    Future<void> pickImage() async {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
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
                          ? Image.file(imageFile!,
                              width: 100, height: 100) // Hiển thị ảnh đã chọn
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
                      Provider.of<AIBotProvider>(context, listen: false)
                          .createAIBot(
                        nameController.text,
                        descriptionController.text,
                        imageFile?.path ??
                            '', // Đường dẫn ảnh hoặc rỗng nếu chưa có ảnh
                      );
                      Navigator.of(context)
                          .pop(); // Đóng dialog sau khi tạo bot
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
