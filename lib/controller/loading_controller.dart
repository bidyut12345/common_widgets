import 'package:flutter/material.dart';

class LoadingController extends ChangeNotifier {
  bool isLoading = false;
  String loadingText = "";

  void showloading({String? text}) {
    isLoading = true;
    loadingText = text ?? "";
    notifyListeners();
  }

  void hideloading() {
    isLoading = false;
    loadingText = "";
    notifyListeners();
  }

  static LoadingController? instance;
}
