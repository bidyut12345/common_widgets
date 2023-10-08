import 'package:flutter/material.dart';

Future showConfirmMessageBox(
  BuildContext context,
  String message, {
  String title = "",
  IconData icon = Icons.question_answer_outlined,
  String button1 = "Yes",
  String button2 = "No",
  String button3 = "",
}) async {
  return showDialog(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          scrollable: true,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          // icon: Icon(
          //   icon,
          //   size: 50,
          // ),
          // backgroundColor: Colors.redAccent,
          backgroundColor: Color.fromARGB(255, 36, 36, 36),

          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context, button1);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(button1),
              ),
            ),
            ElevatedButton(
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
            // const SizedBox(width: 20),
          ],
          contentPadding: EdgeInsets.zero,
          content: Container(
            color: Colors.black45,
            child: Column(
              children: [
                if (title.isNotEmpty) ...[
                  Container(
                    color: const Color.fromARGB(255, 78, 78, 78),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
