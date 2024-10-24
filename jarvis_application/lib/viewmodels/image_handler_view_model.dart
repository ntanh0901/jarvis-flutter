import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ImageHandlerViewModel with ChangeNotifier {
  static const int maxImages = 10;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  List<File> get selectedImages => _selectedImages;
  int get selectedImageCount => _selectedImages.length;
  bool get canAddMoreImages => _selectedImages.length < maxImages;

  Future<Map<String, dynamic>> pickImages() async {
    if (!canAddMoreImages) return {'added': 0, 'limitReached': true};

    final List<XFile> pickedFiles = await _picker.pickMultiImage(limit: maxImages);
    // When the 'limit' parameter is passed to pickMultiImage:
    // 1. On iOS 14+ and Android, it limits the number of images that can be selected.
    // 2. On platforms that don't support this parameter, it will be ignored.
    // 3. If more images are selected than the limit, only the first 'limit' number of images are returned.
    if (pickedFiles == null || pickedFiles.isEmpty) {
      return {'added': 0, 'limitReached': false};
    }

    int remainingSlots = maxImages - _selectedImages.length;
    List<File> newImages = pickedFiles
        .take(remainingSlots)
        .map((xFile) => File(xFile.path))
        .toList();

    _selectedImages.addAll(newImages);
    notifyListeners();

    return {
      'added': newImages.length,
      'limitReached': _selectedImages.length >= maxImages,
      'totalSelected': _selectedImages.length,
    };
  }

  Future<Map<String, dynamic>> takePhoto() async {
    if (!canAddMoreImages) return {'added': 0, 'limitReached': true};

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) {
      return {'added': 0, 'limitReached': false};
    }

    File newImage = File(photo.path);
    _selectedImages.add(newImage);
    notifyListeners();

    return {
      'added': 1,
      'limitReached': _selectedImages.length >= maxImages,
      'totalSelected': _selectedImages.length,
    };
  }

    Future<Map<String, dynamic>> takeScreenshot(
      ScreenshotController screenshotController) async {
    if (!canAddMoreImages) return {'added': 0, 'limitReached': true};

    try {
      final Uint8List? capturedImage = await screenshotController.capture();
      if (capturedImage == null) {
        return {'added': 0, 'limitReached': false};
      }

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(capturedImage);

      _selectedImages.add(imageFile);
      notifyListeners();

      return {
        'added': 1,
        'limitReached': _selectedImages.length >= maxImages,
        'totalSelected': _selectedImages.length,
      };
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      return {'added': 0, 'limitReached': false};
    }
  }

  void removeImage(File image) {
    _selectedImages.remove(image);
    notifyListeners();
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  void removeAllImages() {
    _selectedImages.clear();
    notifyListeners();
  }
}
