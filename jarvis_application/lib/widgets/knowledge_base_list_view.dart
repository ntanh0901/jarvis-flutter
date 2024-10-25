import 'package:flutter/material.dart';
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_config_screen.dart';

class KnowledgeBaseListView extends StatelessWidget {
  const KnowledgeBaseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> knowledgeBaseItems = [
      {
        'icon': Icons.storage_rounded,
        'name': 'Flutter Basics',
        'description': 'A comprehensive guide to Flutter development.',
        'units': 10,
        'size': '1.2MB',
        'editTime': '2023-10-01'
      },
      {
        'icon': Icons.storage_rounded,
        'name': 'Dart Programming',
        'description': 'Learn the Dart programming language.',
        'units': 15,
        'size': '2.3MB',
        'editTime': '2023-09-25'
      },
      {
        'icon': Icons.storage_rounded,
        'name': 'Software Engineering',
        'description': 'Principles and practices of software engineering.',
        'units': 20,
        'size': '3.1MB',
        'editTime': '2023-09-20'
      },
      // Add more items here
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: knowledgeBaseItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.blue, // Background color for the icon
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Icon(
              knowledgeBaseItems[index]['icon'],
              color: Colors.white, // Icon color
            ),
          ),
          title: Text(knowledgeBaseItems[index]['name']),
          subtitle: Text(knowledgeBaseItems[index]['description']), // Add description text
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KnowledgeBaseConfiguration(
                  knowledgeBase: knowledgeBaseItems[index],
                ),
              ),
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(knowledgeBaseItems[index]['name']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Units: ${knowledgeBaseItems[index]['units']}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Size: ${knowledgeBaseItems[index]['size']}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Last Edited: ${knowledgeBaseItems[index]['editTime']}'),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle delete button press
                },
              ),
            ],
          ),
        );
      },
    );
  }
}