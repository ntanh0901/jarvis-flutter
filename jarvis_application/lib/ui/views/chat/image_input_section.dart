import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jarvis_application/styles/chat_screen_styles.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../viewmodels/image_handler_view_model.dart';

class ImageInputSection extends StatelessWidget {
  const ImageInputSection({
    super.key,
    required this.screenshotController,
    required this.inputTextArea,
  });

  final Widget inputTextArea;
  final ScreenshotController screenshotController;

  Widget _buildImagePreview() {
    return Consumer<ImageHandlerViewModel>(
      builder: (context, imageHandler, child) {
        if (imageHandler.selectedImages.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildSelectedImages(imageHandler, context);
      },
    );
  }

  Widget _buildSelectedImages(
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

  Widget _buildImagePreviewItem(
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

  Widget _buildAddImageButton() {
    return Consumer<ImageHandlerViewModel>(
      builder: (context, imageHandler, child) {
        return Tooltip(
          message:
              'Add Images (${imageHandler.selectedImageCount}/${ImageHandlerViewModel.maxImages})',
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: ChatScreenStyles.iconColor),
            onPressed: () => _showOptionMenu(context),
          ),
        );
      },
    );
  }

  void _showOptionMenu(BuildContext context) {
    _showImagePickerOptions(context);
  }

  void _showImagePickerOptions(BuildContext context) {
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
                  isImagePicker: true,
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
              ListTile(
                leading: const Icon(Icons.screenshot),
                title: const Text('Take a screenshot'),
                onTap: () => _handleImageOptionTap(
                  context,
                  () =>
                      Provider.of<ImageHandlerViewModel>(context, listen: false)
                          .takeScreenshot(screenshotController),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImageOptionTap(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action, {
    bool isImagePicker = false,
  }) async {
    final imageHandler =
        Provider.of<ImageHandlerViewModel>(context, listen: false);

    if (!imageHandler.canAddMoreImages) {
      _showImageAddedFeedback(context, {
        'added': 0,
        'totalSelected': imageHandler.selectedImageCount,
        'limitReached': true
      });
      return;
    }

    // Wait for the action to complete
    final result = await action();

    // Show feedback after the action is completed
    if (context.mounted) {
      if (result['error'] != null) {
        _showErrorFlushbar(context, result['error']);
      } else {
        _showImageAddedFeedback(context, result);
      }
    }
  }

  void _showErrorFlushbar(BuildContext context, String errorMessage) {
    ChatScreenStyles.createCenteredFlushbar(
      message: errorMessage,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: Icons.error_outline,
    ).show(context);
  }

  void _showImageAddedFeedback(
      BuildContext context, Map<String, dynamic> result) {
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

  void _confirmRemoveAllImages(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ChatScreenStyles.inputContainerDecoration(context),
      child: Column(
        children: [
          _buildImagePreview(),
          Padding(
            padding: ChatScreenStyles.inputContainerPadding,
            child: Row(
              children: [
                _buildAddImageButton(),
                Expanded(child: inputTextArea),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
