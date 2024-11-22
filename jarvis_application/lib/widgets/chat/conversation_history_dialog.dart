import 'package:flutter/material.dart';

class ConversationHistoryDialog extends StatefulWidget {
  final List<Map<String, dynamic>> initialItems;
  final String? cursor;
  final ValueChanged<List<Map<String, dynamic>>> onItemsUpdated;
  final ValueChanged<String>  onItemSelected;
  const ConversationHistoryDialog({
    Key? key,
    required this.initialItems,
    required this.cursor,
    required this.onItemsUpdated,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _ConversationHistoryDialogState createState() =>
      _ConversationHistoryDialogState();
}

class _ConversationHistoryDialogState extends State<ConversationHistoryDialog> {
  late List<Map<String, dynamic>> items;
  String? currentCursor;
  late List<Map<String, dynamic>> filteredItems;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.initialItems); // copy list
    filteredItems = List.from(items); // copy for filtering
    currentCursor = widget.cursor;
  }

  void _deleteItem(int index) {
    setState(() {
      filteredItems.removeAt(index); // delete item
    });

    // return updating for ChatPage
    widget.onItemsUpdated(filteredItems);
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.day}/${date.month}/${date.year}";
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(items); // Hiển thị lại tất cả nếu không có query
      } else {
        filteredItems = items
            .where((item) => item['title']
            .toLowerCase()
            .contains(query.toLowerCase())) // Lọc theo title
            .toList();
      }
    });
  }

  Widget _buildDialogHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

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
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    onChanged: _filterItems, // Lọc danh sách khi nhập
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            _buildDialogHeader(context, 'Conversation History'),
            _buildSearchBarWithIcons(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_formatDate(item['createdAt'])),
                    isThreeLine: false,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(index), // Xóa conversation
                    ),
                    onTap: (){
                      widget.onItemSelected(
                        item['id'] as String,
                      );
                      Navigator.of(context).pop();
                    }
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
