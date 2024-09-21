import 'package:flutter/material.dart';

class LoadingController extends ChangeNotifier {
  bool isLoading = false;
  String loadingText = "";
  int loadingCount = 0;
  Map<BuildContext, BuildContext> contexts = {};
  void showloading({String? text, BuildContext? context, Function? onCancel}) {
    if (context != null && context.mounted) {
      showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (contextd) {
          contexts.addAll({context: contextd});
          return AlertDialog(
            title: Text("Dialog"),
            content: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 100,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      isLoading = true;
      loadingText = text ?? "";
      notifyListeners();
      loadingCount += 1;
      // print("loading$loadingCount");
    }
  }

  void hideloading({BuildContext? context}) {
    if (context != null && context.mounted) {
      BuildContext? contextd = contexts[context];
      Navigator.pop(contextd!);
    } else {
      loadingCount -= 1;
      isLoading = loadingCount > 0;
      if (loadingCount < 0) loadingCount = 0;
      // print("unloading$loadingCount");
      loadingText = "";
      notifyListeners();
    }
  }

  void resetLoading() {
    loadingCount = 0;
    isLoading = false;
    // print("reset$loadingCount");
    loadingText = "";
    notifyListeners();
  }

  static LoadingController? instance;
}
