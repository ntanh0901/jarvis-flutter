import 'package:flutter/material.dart';
import '../../data/models/kb_unit.dart';
import '../widgets/enable_unit_switch.dart';

class UnitsListView extends StatelessWidget {
  final List<Unit> units;

  const UnitsListView({super.key, required this.units});

  String _formatSize(int sizeInBytes) {
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.blue, // Background color for the icon
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: const Icon(
              Icons.folder,
              color: Colors.white, // Icon color
            ),
          ),
          title: Text(unit.name),
          subtitle: Text('Source: ${unit.type}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //const EnableUnitSwitch(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(unit.name),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align items to the left
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Source: ${unit.type}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Size: ${_formatSize(unit.size)}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Create Time: ${unit.createdAt}'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Latest Update: ${unit.updatedAt}'),
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
              // IconButton(
              //   icon: const Icon(Icons.delete),
              //   onPressed: () {
              //     // Handle delete button press
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
