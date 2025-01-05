import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/viewmodels/knowledge_base_viewmodel.dart';

class LocalFilesScreen extends ConsumerStatefulWidget {
  final String knowledgeBaseId;

  const LocalFilesScreen({super.key, required this.knowledgeBaseId});

  @override
  _LocalFilesScreenState createState() => _LocalFilesScreenState();
}

class _LocalFilesScreenState extends ConsumerState<LocalFilesScreen> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      await ref.read(kbViewModelProvider.notifier).addLocalFileUnit(
            widget.knowledgeBaseId,
            _selectedFile!.name!,
            _selectedFile!.bytes!,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _selectedFile = null;
      });
    }
  }

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
                  'assets/local_files.png',
                  width: 50.0,
                  height: 50.0,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'Local Files',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32.0),
            const Text(
              'Upload local file:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Icon(
                        Icons.upload_file,
                        size: 50,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        _selectedFile != null
                            ? _selectedFile!.name
                            : 'Click or drag file to this area to upload',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Support for a single or bulk upload.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Strictly prohibit from uploading company data or other band files',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed:
                    _selectedFile != null && !_isUploading ? _uploadFile : null,
                child: _isUploading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
