import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadDialog extends StatelessWidget {
  final Function(File?) onFilePicked;

  const UploadDialog({Key? key, required this.onFilePicked}) : super(key: key);

  Future<void> _pickPdfFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Chỉ cho phép chọn file PDF
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Navigator.of(context).pop(); // Đóng hộp thoại sau khi chọn file
      onFilePicked(file); // Trả file về qua callback
    } else {
      Navigator.of(context).pop(); // Đóng nếu không chọn file
      onFilePicked(null); // Trả null nếu người dùng hủy chọn
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Upload PDF'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Use Chat with PDF to easily get intelligent summaries and answers for your documents.'),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _pickPdfFile(context), // Gọi hàm chọn file
            child: Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf, size: 50),
                  const SizedBox(height: 10),
                  const Text('Click or drag and drop here to upload'),
                  const SizedBox(height: 5),
                  Text('File types supported: PDF  |  Max file size: 50MB',
                      style:
                      TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
