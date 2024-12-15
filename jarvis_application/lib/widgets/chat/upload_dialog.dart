import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadDialog extends StatelessWidget {
  final Function(File?) onFilePicked;

  const UploadDialog({super.key, required this.onFilePicked});

  Future<void> _pickPdfFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Only allow PDF files
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Navigator.of(context).pop(); // Close the dialog after selecting the file
      onFilePicked(file); // Return the file via callback
    } else {
      Navigator.of(context).pop(); // Close the dialog if the user cancels
      onFilePicked(null); // Return null if no file was picked
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Upload PDF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            // Dialog content

            const SizedBox(height: 8),
            const Text(
              'Use Chat with PDF to easily get intelligent summaries and answers for your documents.',
            ),
            const SizedBox(height: 16),
            DottedBorder(
              color: Colors.grey,
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () => _pickPdfFile(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Click or drag and drop here to upload',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'File types supported: PDF | Max file size: 50MB',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
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
