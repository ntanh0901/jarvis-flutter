import 'package:flutter/material.dart';

class ResultPublishPage extends StatelessWidget {
  static const String routeName = '/result-publish'; // Route name

  final List<Map<String, dynamic>> selectedPlatforms;

  const ResultPublishPage({
    Key? key,
    required this.selectedPlatforms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publishing Result'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 8.0),
                  Text(
                    '🎉 Publication submitted!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Results Section
            Expanded(
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Publishing platform',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: selectedPlatforms.length,
                          itemBuilder: (context, index) {
                            final platform = selectedPlatforms[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  // Platform Icon
                                  Image.asset(
                                    platform['icon'],
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 16.0),
                                  // Platform Name
                                  Expanded(
                                    child: Text(
                                      platform['name'],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // Status Indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: const Text(
                                      'Success',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  // Open Button
                                  TextButton(
                                    onPressed: () {
                                      // Add logic to open platform-specific page
                                      print('Opening ${platform['name']}');
                                    },
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
