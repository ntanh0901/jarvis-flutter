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
            Wrap(
              spacing: 0, // Removes spacing between icons
              children: [
                _buildIconButton(Icons.add_comment, 'new_chat'),
                _buildIconButton(Icons.access_time, 'view_history'),
              ],
            ),
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
                  backgroundColor: Colors.grey,
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
            const SizedBox(width: 2),
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
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      onPressed: () => onIconPressed(action),
    );
  }
}
