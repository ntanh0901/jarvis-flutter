import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:jarvis_application/styles/chat_screen_styles.dart';
import 'package:jarvis_application/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

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
    File imageFile = imageHandler.selectedImages[idx];
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          width: 50,
          height: 50,
          child: Image.file(imageFile, fit: BoxFit.cover),
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ImageHandlerViewModel>(
          builder: (context, imageHandler, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.image_outlined,
                      color: ChatScreenStyles.iconColor),
                  title: const Text('Choose from Gallery'),
                  onTap: () => _handleImageOptionTap(
                      context, true, imageHandler.pickImages,
                      isImagePicker: true),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: ChatScreenStyles.iconColor),
                  title: const Text('Take a Photo'),
                  onTap: () => _handleImageOptionTap(context,
                      imageHandler.canAddMoreImages, imageHandler.takePhoto),
                ),
                ListTile(
                  leading: const Icon(Icons.screenshot_outlined,
                      color: ChatScreenStyles.iconColor),
                  title: const Text('Capture Screenshot'),
                  onTap: () => _handleImageOptionTap(
                      context,
                      imageHandler.canAddMoreImages,
                      () => imageHandler.takeScreenshot(screenshotController)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFlushbar(
    BuildContext context,
    ImageHandlerViewModel imageHandler, {
    int? totalSelected,
    int? added,
    bool isLimitReached = false,
  }) {
    Flushbar(
      duration: Duration(seconds: isLimitReached ? 3 : 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.9),
      messageColor: Colors.white,
      messageText: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Max image limit reached ${imageHandler.selectedImageCount}/${ImageHandlerViewModel.maxImages}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (isLimitReached && totalSelected != null && added != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Added $added image(s). ${totalSelected - ImageHandlerViewModel.maxImages} image(s) discarded.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    ).show(context);
  }

  void _handleImageOptionTap(BuildContext context, bool canAddMore,
      Future<Map<String, dynamic>> Function() action,
      {bool isImagePicker = false}) async {
    final imageHandler =
        Provider.of<ImageHandlerViewModel>(context, listen: false);

    if (isImagePicker || canAddMore) {
      Navigator.pop(context);
      final result = await action();

      if (!context.mounted) return;

      if (isImagePicker && result['limitReached']) {
        _showFlushbar(
          context,
          imageHandler,
          totalSelected: result['totalSelected'],
          added: result['added'],
          isLimitReached: true,
        );
      } else {
        _showImageAddedFeedback(context, result);
      }
    } else {
      _showFlushbar(context, imageHandler);
    }
  }

  void _showImageAddedFeedback(
      BuildContext context, Map<String, dynamic> result) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        if (result['added'] > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Added ${result['added']} image(s). Total: ${result['totalSelected']}/${ImageHandlerViewModel.maxImages}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (result['limitReached']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Image limit reached. You can add up to ${ImageHandlerViewModel.maxImages} images.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All images removed'),
                        duration: Duration(seconds: 2),
                      ),
                    );
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
