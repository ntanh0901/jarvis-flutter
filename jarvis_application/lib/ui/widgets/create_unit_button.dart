import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/views/knowledgeBase/add_new_unit_screen.dart';

class CreateUnitButton extends StatelessWidget {
  const CreateUnitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          child: InkWell(
            onTap: () {
              //Add new unit
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewUnit()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.add_circle, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    'Add Unit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
