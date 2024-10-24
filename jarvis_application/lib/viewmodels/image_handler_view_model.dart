import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

class ImageHandlerViewModel extends ChangeNotifier {
  final List<Uint8List> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  static const int maxImages = 10;

  List<Uint8List> get selectedImages => _selectedImages;
  int get selectedImageCount => _selectedImages.length;
  bool get canAddMoreImages => _selectedImages.length < maxImages;

  Future<Map<String, dynamic>> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    return _processPickedImages(pickedFiles);
  }

  Future<Map<String, dynamic>> takePhoto() async {
    if (!canAddMoreImages) {
      return {
        'added': 0,
        'limitReached': true,
        'totalSelected': _selectedImages.length
      };
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    
    if (photo == null) {
      return {
        'added': 0,
        'limitReached': false,
        'totalSelected': _selectedImages.length
      };
    }

    final bytes = await photo.readAsBytes();
    _selectedImages.add(bytes);
    notifyListeners();

    return {
      'added': 1,
      'limitReached': _selectedImages.length >= maxImages,
      'totalSelected': _selectedImages.length,
    };
  }

  Future<Map<String, dynamic>> _processPickedImages(List<XFile>? pickedFiles) async {
    if (pickedFiles == null || pickedFiles.isEmpty) {
      return {
        'added': 0,
        'limitReached': false,
        'totalSelected': _selectedImages.length
      };
    }

    int remainingSlots = maxImages - _selectedImages.length;
    List<Uint8List> newImages = [];

    for (var i = 0; i < pickedFiles.length && i < remainingSlots; i++) {
      final bytes = await pickedFiles[i].readAsBytes();
      newImages.add(bytes);
    }

    _selectedImages.addAll(newImages);
    notifyListeners();

    return {
      'added': newImages.length,
      'limitReached': _selectedImages.length >= maxImages,
      'totalSelected': _selectedImages.length,
    };
  }

  Future<Map<String, dynamic>> takeScreenshot(
      ScreenshotController controller) async {
    if (!canAddMoreImages) {
      return {
        'added': 0,
        'limitReached': true,
        'totalSelected': _selectedImages.length
      };
    }

    final Uint8List? screenshot = await controller.capture();
    if (screenshot == null) {
      return {
        'added': 0,
        'limitReached': false,
        'totalSelected': _selectedImages.length
      };
    }

    _selectedImages.add(screenshot);
    notifyListeners();

    return {
      'added': 1,
      'limitReached': _selectedImages.length >= maxImages,
      'totalSelected': _selectedImages.length,
    };
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
