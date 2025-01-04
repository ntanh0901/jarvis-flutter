import 'package:flutter/material.dart';
import 'package:jarvis_application/data/models/kb_unit.dart';

class UnitsListView extends StatelessWidget {
  final List<Unit> units;

  const UnitsListView({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return ListTile(
          title: Text(unit.name),
          //subtitle: Text(unit.description),
        );
      },
    );
  }
}
