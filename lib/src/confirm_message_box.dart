import 'package:common_widgets/common_widgets.dart';
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
  var isDarkMode_ = ThemeHelper.isDarkMode(context);
  print(CommonWidgetConfig.appBrightnes);
  return showDialog(
      context: context,
      useRootNavigator: false,
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
          backgroundColor: isDarkMode_ ? Color.fromARGB(255, 36, 36, 36) : Color.fromARGB(255, 172, 172, 172),

          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context, button1);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: isDarkMode_ ? Colors.white : Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(button1),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, button2);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: isDarkMode_ ? Colors.white : Colors.black,
              ),
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: isDarkMode_ ? Colors.white : Colors.black,
                ),
                child: Text(button3),
              )
            ],
            // const SizedBox(width: 20),
          ],
          contentPadding: EdgeInsets.zero,
          content: Container(
            color: isDarkMode_ ? Colors.black45 : Colors.white54,
            child: Column(
              children: [
                if (title.isNotEmpty) ...[
                  Container(
                    color: isDarkMode_ ? const Color.fromARGB(255, 78, 78, 78) : Color.fromARGB(255, 107, 107, 107),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            // textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isDarkMode_ ? Colors.white : Colors.black),
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
