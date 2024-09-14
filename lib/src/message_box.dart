import 'package:flutter/material.dart';

Future showMessageBox(
  BuildContext context,
  String message, {
  String title = "",
  IconData icon = Icons.info,
}) async {
  return showDialog(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          actionsAlignment: MainAxisAlignment.center,
          // buttonPadding: EdgeInsets.only(bottom: 20),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  autofocus: true,
                  onPressed: () => Navigator.pop(cntxt),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
            )
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
          icon: Icon(
            icon,
            size: 100,
          ),
          title: title.isEmpty
              ? null
              : Text(
                  title,
                  textAlign: TextAlign.center,
                ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
}
