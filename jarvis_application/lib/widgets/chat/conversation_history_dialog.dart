import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../data/models/assistant_dto.dart';
import '../../data/models/conversations_query_params.dart';
import '../../data/models/conversations_res.dart';
import '../../providers/dio_provider.dart';
import '../../ui/widgets/error_dialog.dart';

class ConversationHistoryDialog extends ConsumerStatefulWidget {
  final String? cursor;
  final ValueChanged<String> onItemSelected;

  const ConversationHistoryDialog({
    super.key,
    required this.cursor,
    required this.onItemSelected,
  });

  @override
  _ConversationHistoryDialogState createState() =>
      _ConversationHistoryDialogState();
}

class _ConversationHistoryDialogState
    extends ConsumerState<ConversationHistoryDialog> {
  late List<Map<String, dynamic>> items;
  late List<Map<String, dynamic>> filteredItems;
  String? currentCursor;
  bool isLoading = true;
  late Dio dio;

  @override
  void initState() {
    super.initState();
    items = [];
    filteredItems = [];
    currentCursor = widget.cursor;
    dio = ref.read(dioProvider);
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    setState(() {
      isLoading = true;
    });
    ConversationsQueryParams queryParams = ConversationsQueryParams(
      cursor: '',
      limit: 100,
      assistantId: Id.CLAUDE_3_HAIKU_20240307,
      assistantModel: Model.DIFY,
    );

    try {
      // Send request
      final response = await dio.get(
        ApiEndpoints.getConversations,
        queryParameters: queryParams.toJson(),
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
          filteredItems = List.from(items);
          currentCursor = conversations.cursor;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        String errorMessage =
            "Request failed with status: ${response.statusCode}\nReason: ${response.statusMessage}";
        _showErrorDialog(context, "Error", errorMessage);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(context, "Error", "An error occurred: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: title,
          message: message,
        );
      },
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.day}/${date.month}/${date.year}";
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(items); // Show all if no query
      } else {
        filteredItems = items
            .where((item) =>
                item['title'].toLowerCase().contains(query.toLowerCase()))
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
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  Expanded(
                    child: TextField(
                      onChanged: _filterItems,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogHeader(context, 'Conversation History'),
            const SizedBox(height: 8),
            _buildSearchBarWithIcons(),
            const SizedBox(height: 16),
            isLoading
                ? const Expanded(
                    child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        backgroundColor: Colors.grey, // Background color
                      ),
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(
                            item['title']?.trim(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            _formatDate(item['createdAt']),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            widget.onItemSelected(item['id'] as String);
                            Navigator.of(context).pop();
                          },
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
