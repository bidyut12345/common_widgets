import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Loading extends StatelessWidget {
  const Loading(
      {Key? key, required this.child, required this.isLoading, this.loadingText = "", this.fit = StackFit.expand})
      : super(key: key);
  final Widget child;
  final bool isLoading;
  final String loadingText;
  final StackFit fit;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: fit,
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: AlertDialog(
                    clipBehavior: Clip.antiAlias,
                    content: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!kDebugMode) const CircularProgressIndicator(),
                          if (loadingText.isNotEmpty)
                            const SizedBox(
                              height: 20,
                            ),
                          if (loadingText.isNotEmpty)
                            Text(
                              loadingText,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
