import 'package:flutter/material.dart';

class WebsiteScreen extends StatelessWidget {
  const WebsiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Unit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/website.png',
                  width: 50.0,
                  height: 50.0,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'Website',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32.0),
            const Text(
              'Website Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Website URL:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'URL',
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle connect action
                },
                child: const Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}