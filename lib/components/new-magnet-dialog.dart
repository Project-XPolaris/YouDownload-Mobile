import 'package:flutter/material.dart';

class NewMagnetDialog extends StatefulWidget {
  final Function(String) onCreate;
  final Function onCancel;

  NewMagnetDialog({this.onCreate, this.onCancel});

  @override
  _NewMagnetDialogState createState() => _NewMagnetDialogState();
}

class _NewMagnetDialogState extends State<NewMagnetDialog> {
  String link = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New magnet task"),
      content: Container(
        child: TextField(
          decoration: InputDecoration(hintText: "link"),
          onChanged: (text) {
            setState(() {
              link = text;
            });
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (widget.onCreate != null && link.isNotEmpty) {
                widget.onCreate(link);
              }
            },
            child: Text("Create")),
        TextButton(
            onPressed: () {
              if (widget.onCancel != null) {
                widget.onCancel();
              }
            },
            child: Text("Cancel"))
      ],
    );
  }
}
