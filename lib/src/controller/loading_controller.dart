import 'package:flutter/material.dart';

class LoadingController extends ChangeNotifier {
  bool isLoading = false;
  String loadingText = "";
  int loadingCount = 0;
  void showloading({String? text}) {
    isLoading = true;
    loadingText = text ?? "";
    notifyListeners();
    loadingCount += 1;
    print("loading$loadingCount");
  }

  void hideloading() {
    loadingCount -= 1;
    isLoading = loadingCount > 0;
    if (loadingCount < 0) loadingCount = 0;
    print("unloading$loadingCount");
    loadingText = "";
    notifyListeners();
  }

  static LoadingController? instance;
}
