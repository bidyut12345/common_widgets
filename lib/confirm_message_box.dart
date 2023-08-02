import 'package:flutter/material.dart';

Future showConfirmMessageBox(
  BuildContext context,
  String message, {
  String title = "",
  IconData icon = Icons.question_mark_outlined,
  String button1 = "Yes",
  String button2 = "No",
  String button3 = "",
}) async {
  return showDialog(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          icon: Icon(
            icon,
            size: 50,
          ),
          title: title.isEmpty
              ? null
              : Text(
                  title,
                  textAlign: TextAlign.center,
                ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 5),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, button1);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(button1),
              ),
            ),
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context, button2);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(button2),
              ),
            ),
            if (button3.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, button3);
                },
                child: Text(button3),
              )
            ],
          ],
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
}
