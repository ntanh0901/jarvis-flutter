import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../styles/chat_screen_styles.dart';

class ImagePickerHelper {
  static void showImagePickerOptions(
    BuildContext context, {
    required ScreenshotController screenshotController,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .pickImages(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .takePhoto(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _handleImageOptionTap(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    final imageHandler =
        Provider.of<ImageHandlerViewModel>(context, listen: false);

    if (!imageHandler.canAddMoreImages) {
      _showImageAddedFeedback(context, {
        'added': 0,
        'totalSelected': imageHandler.selectedImageCount,
        'limitReached': true,
      });
      return;
    }

    final result = await action();

    if (context.mounted) {
      if (result['error'] != null) {
        _showErrorFlushbar(context, result['error']);
      } else {
        _showImageAddedFeedback(context, result);
      }
    }
  }

  static void _showErrorFlushbar(BuildContext context, String errorMessage) {
    ChatScreenStyles.createCenteredFlushbar(
      message: errorMessage,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: Icons.error_outline,
    ).show(context);
  }

  static void _showImageAddedFeedback(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    String message;
    IconData icon;
    Color backgroundColor;

    if (result['added'] > 0) {
      message =
          'Added ${result['added']} image(s). Total: ${result['totalSelected']}/${ImageHandlerViewModel.maxImages}';
      icon = Icons.check_circle_outline;
      backgroundColor = Colors.green;
    } else if (result['limitReached']) {
      message =
          'Max image limit reached (${result['totalSelected']}/${ImageHandlerViewModel.maxImages})';
      icon = Icons.warning_amber_rounded;
      backgroundColor = Theme.of(context).colorScheme.error;
    } else {
      message = 'No images added';
      icon = Icons.info_outline;
      backgroundColor = Colors.blue;
    }

    ChatScreenStyles.createCenteredFlushbar(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
    ).show(context);
  }

  static Widget buildSelectedImages(BuildContext context) {
    return Consumer<ImageHandlerViewModel>(
      builder: (context, imageHandler, child) {
        if (imageHandler.selectedImages.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildSelectedImagesPreview(imageHandler, context);
      },
    );
  }

  static Widget _buildSelectedImagesPreview(
      ImageHandlerViewModel imageHandler, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageHandler.selectedImages.length,
                itemBuilder: (context, idx) =>
                    _buildImagePreviewItem(imageHandler, idx, context),
              ),
            ),
          ),
          Tooltip(
            message: 'Remove All Images',
            child: IconButton(
              icon: const Icon(Icons.delete_sweep,
                  color: ChatScreenStyles.iconColor),
              onPressed: () => _confirmRemoveAllImages(context),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildImagePreviewItem(
      ImageHandlerViewModel imageHandler, int idx, BuildContext context) {
    Uint8List imageData = imageHandler.selectedImages[idx];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              imageData,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => imageHandler.removeImageAt(idx),
            child: Container(
              decoration: ChatScreenStyles.removeImageButtonDecoration(context),
              child: const Icon(
                Icons.close,
                size: 14,
                color: ChatScreenStyles.removeImageButtonIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static void _confirmRemoveAllImages(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove All Images"),
          content: const Text("Are you sure you want to remove all images?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Remove"),
              onPressed: () {
                context.read<ImageHandlerViewModel>().removeAllImages();
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ChatScreenStyles.createCenteredFlushbar(
                      message: 'All images removed',
                      backgroundColor: Colors.green,
                      icon: Icons.delete_sweep,
                    ).show(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
