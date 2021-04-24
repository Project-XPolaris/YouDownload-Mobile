import 'package:flutter/material.dart';

class NewDownloadDialog extends StatefulWidget {
  final Function(String) onCreate;
  final Function onCancel;

  NewDownloadDialog({this.onCreate, this.onCancel});
  @override
  _NewDownloadDialogState createState() => _NewDownloadDialogState();
}

class _NewDownloadDialogState extends State<NewDownloadDialog> {
  String link = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New download task"),
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
