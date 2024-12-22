import 'package:flutter/material.dart';

class IconButtonsRow extends StatelessWidget {
  final void Function(String action) onIconPressed;
  final int remainUsage;

  const IconButtonsRow({
    super.key,
    required this.onIconPressed,
    required this.remainUsage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconButton(Icons.add_comment, 'add_comment'),
            _buildIconButton(Icons.picture_as_pdf, 'upload_pdf'),
            _buildIconButton(Icons.access_time, 'view_history'),
          ],
        ),

        // Remaining usage
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$remainUsage',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.local_fire_department_sharp,
              size: 22,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String action) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 18,
      onPressed: () => onIconPressed(action),
    );
  }
}
