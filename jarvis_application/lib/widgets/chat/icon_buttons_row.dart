import 'package:flutter/material.dart';

class IconButtonsRow extends StatelessWidget {
  final void Function(String action) onIconPressed;

  const IconButtonsRow({
    Key? key,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(Icons.add_comment, 'add_comment'),
        _buildIconButton(Icons.picture_as_pdf, 'upload_pdf'),
        _buildIconButton(Icons.menu_book_outlined, 'view_book'),
        _buildIconButton(Icons.access_time, 'view_history'),
        _buildIconButton(Icons.content_cut, 'edit_content'),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 18,
        onPressed: () => onIconPressed(action), // Gửi action đến ActionRow
      ),
    );
  }
}
