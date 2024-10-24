import 'package:flutter/material.dart';
import 'package:jarvis_application/widgets/enable_unit_switch.dart';

class UnitsListView extends StatelessWidget {
  const UnitsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> unitItems = [
      {
        'icon': Icons.folder,
        'name': 'Unit 1',
        'source': 'Local File',
        'size': '500KB',
        'createTime': '2023-10-01',
        'latestUpdate': '2023-10-01'
      },
      {
        'icon': Icons.folder,
        'name': 'Unit 2',
        'source': 'Local File',
        'size': '1.2MB',
        'createTime': '2023-09-25',
        'latestUpdate': '2023-09-25'
      },
      {
        'icon': Icons.folder,
        'name': 'Unit 3',
        'source': 'Local File',
        'size': '750KB',
        'createTime': '2023-09-20',
        'latestUpdate': '2023-09-20'
      },
      // Add more items here
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: unitItems.length,
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
              unitItems[index]['icon'],
              color: Colors.white, // Icon color
            ),
          ),
          title: Text(unitItems[index]['name']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const EnableUnitSwitch(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(unitItems[index]['name']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align items to the left
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Source: ${unitItems[index]['source']}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Size: ${unitItems[index]['size']}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Create Time: ${unitItems[index]['createTime']}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Latest Update: ${unitItems[index]['latestUpdate']}'),
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