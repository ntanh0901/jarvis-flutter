import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class ImageHandlerViewModel extends ChangeNotifier {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  ScreenshotController screenshotController = ScreenshotController();
  bool _isPickerActive = false;

  File? get selectedImage => _selectedImage;

  Future<File> _resizeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    final resized = img.copyResize(image!, width: 800);
    final resizedBytes = img.encodeJpg(resized, quality: 85);
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/resized_image.jpg');
    await tempFile.writeAsBytes(resizedBytes);
    return tempFile;
  }

  Future<void> pickImage() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final resizedImage = await _resizeImage(File(image.path));
        _selectedImage = resizedImage;
        notifyListeners();
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> takePhoto() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final resizedImage = await _resizeImage(File(photo.path));
        _selectedImage = resizedImage;
        notifyListeners();
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> captureScreenshot(BuildContext context) async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final screenshot = await screenshotController.capture();
      if (screenshot != null) {
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/screenshot.png');
        await tempFile.writeAsBytes(screenshot);
        final resizedImage = await _resizeImage(tempFile);
        _selectedImage = resizedImage;
        notifyListeners();
      }
    } finally {
      _isPickerActive = false;
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
