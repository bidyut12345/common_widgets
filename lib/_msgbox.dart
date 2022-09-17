import 'package:flutter/material.dart';
import '_fixed_panel.dart';

msgBox({required String title, required String message, required Map<String, IconData> buttons, required BuildContext context}) {
  // Widget okButton = ElevatedButton.icon(
  //   icon: const Icon(Icons.keyboard_option_key),
  //   label: const Text("YES"),
  //   onPressed: () {
  //     Navigator.pop(context, "YES");
  //   },
  // );
  // Widget cancelButton = ElevatedButton.icon(
  //   icon: const Icon(Icons.cancel),
  //   label: const Text("NO"),
  //   onPressed: () {
  //     Navigator.pop(context, "NO");
  //   },
  // );

  // set up the AlertDialog
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: buttons.keys
        .map((String e) => ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(120, 50)),
              icon: Icon(buttons[e]),
              label: Text(e.toString()),
              onPressed: () {
                Navigator.pop(context, e);
              },
            ))
        .toList(),
  );
}

msgBoxOkOnly({required BuildContext context, required String title, required String message, Function? onComplete}) {
  var sc = ScrollController();
  showDialog(
      context: context,
      builder: (cnt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          content: FixedPanelTop(
            topPanelHeight: 57,
            topChild: AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
            ),
            child: FixedPanelBottom(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: sc,
                child: SingleChildScrollView(
                  controller: sc,
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    constraints: BoxConstraints(minHeight: 100),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomPanelHeight: 60,
              bottomChild: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Ok"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }).then((value) {
    if (onComplete != null) onComplete();
  });
}
