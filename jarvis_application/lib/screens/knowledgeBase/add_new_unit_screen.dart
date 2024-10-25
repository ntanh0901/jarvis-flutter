import 'package:flutter/material.dart';
import 'package:jarvis_application/screens/knowledgeBase/units/local_files_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/units/website_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/units/google_drive_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/units/slack_screen.dart';
import 'package:jarvis_application/screens/knowledgeBase/units/confluence_screen.dart';

class AddNewUnit extends StatefulWidget {
  const AddNewUnit({super.key});

  @override
  _AddNewUnitState createState() => _AddNewUnitState();
}

class _AddNewUnitState extends State<AddNewUnit> {
  int? _selectedIndex = 0;

  final List<Map<String, dynamic>> unitItems = [
    {
      'icon': 'assets/local_files.png', // Path to the image asset
      'name': 'Local files',
      'description': 'Upload pdf, docx, ...'
    },
    {
      'icon': 'assets/website.png', // Path to the image asset
      'name': 'Website',
      'description': 'Connect Website to get data'
    },
    {
      'icon': 'assets/google_drive.png', // Path to the image asset
      'name': 'Google Drive',
      'description': 'Connect Google Drive to get data'
    },
    {
      'icon': 'assets/slack.png', // Path to the image asset
      'name': 'Slack',
      'description': 'Connect Slack to get data'
    },
    {
      'icon': 'assets/confluence.png', // Path to the image asset
      'name': 'Confluence',
      'description': 'Connect Confluence to get data'
    },
  ];

  void _navigateToUnitScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LocalFilesScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WebsiteScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleDriveScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SlackScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConfluenceScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Unit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: unitItems.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                              color: isSelected ? Colors.blue : Colors.transparent,
                            ),
                            child: const Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 12.0,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Image.asset(
                            unitItems[index]['icon']!,
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                unitItems[index]['name']!,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                unitItems[index]['description']!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _selectedIndex != null
                      ? () {
                          _navigateToUnitScreen(context, _selectedIndex!);
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}