import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandlerViewModel with ChangeNotifier {
  static const int maxImages = 10;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  List<File> get selectedImages => _selectedImages;
  int get selectedImageCount => _selectedImages.length;
  bool get canAddMoreImages => _selectedImages.length < maxImages;

  Future<Map<String, dynamic>> pickImages() async {
    if (!canAddMoreImages) return {'added': 0, 'limitReached': true};

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
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
