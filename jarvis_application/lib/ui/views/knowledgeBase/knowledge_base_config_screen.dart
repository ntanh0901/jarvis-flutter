import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/views/knowledgeBase/edit_kb_screen.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/create_unit_button.dart';
import '../../widgets/units_list_view.dart';

class KnowledgeBaseConfiguration extends StatelessWidget {
  final Map<String, dynamic> knowledgeBase;

  const KnowledgeBaseConfiguration({super.key, required this.knowledgeBase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledge Base / ${knowledgeBase['name']}'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    knowledgeBase['icon'],
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            knowledgeBase['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditKB(
                                    name: knowledgeBase['name'],
                                    description: knowledgeBase['description'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Text('Units: ${knowledgeBase['units']}'),
                          const SizedBox(width: 16.0),
                          Text('Size: ${knowledgeBase['size']}'),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const CreateUnitButton(),
                ],
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            const UnitsListView(),
          ],
        ),
      ),
    );
  }
}
