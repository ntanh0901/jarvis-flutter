import 'package:flutter/material.dart';

class EnableUnitSwitch extends StatefulWidget {
  const EnableUnitSwitch({super.key});

  @override
  _EnableUnitSwitchState createState() => _EnableUnitSwitchState();
}

class _EnableUnitSwitchState extends State<EnableUnitSwitch> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isEnabled,
      onChanged: (value) {
        setState(() {
          _isEnabled = value;
        });
      },
    );
  }
}