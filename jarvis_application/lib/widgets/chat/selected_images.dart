import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jarvis_application/styles/chat_screen_styles.dart';
import 'package:jarvis_application/ui/viewmodels/image_handler_view_model.dart';
import 'package:provider/provider.dart';

class SelectedImages extends StatelessWidget {
  const SelectedImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageHandlerViewModel>(
      builder: (context, imageHandler, child) {
        if (imageHandler.selectedImages.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildSelectedImagesPreview(imageHandler, context);
      },
    );
  }

  Widget _buildSelectedImagesPreview(
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
              onPressed: () {
                // Confirm and remove all images
              },
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
}
