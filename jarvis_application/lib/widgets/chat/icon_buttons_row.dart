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
            _buildIconButton(Icons.add_comment, 'new_chat'),
            _buildIconButton(Icons.picture_as_pdf, 'upload_pdf'),
            _buildIconButton(Icons.access_time, 'view_history'),
          ],
        ),

        // Remaining usage
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (remainUsage == -1)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey, // Background color
                ),
              )
            else
              Text(
                '$remainUsage',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            const SizedBox(width: 4),
            const Icon(
              Icons.local_fire_department_sharp,
              size: 22,
              color: Colors.blueAccent,
            ),
          ],
        )
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
