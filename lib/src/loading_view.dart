import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
import '../common_widgets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.child, this.fit = StackFit.loose});
  final Widget child;
  final StackFit fit;
  @override
  Widget build(BuildContext context) {
    LoadingController.instance ??= LoadingController(); //Provider.of<LoadingController>(context, listen: true);
    return ListenableBuilder(
        listenable: LoadingController.instance ?? LoadingController(),
        builder: (context, _) {
          return Stack(
            fit: fit,
            children: [
              child,
              LoadingController.instance!.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        clipBehavior: Clip.antiAlias,
                        content: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (kDebugMode)
                                const Text(
                                  "Loading...\n[Circularprogressbar is Hidden in DEBUG MODE]",
                                  textAlign: TextAlign.center,
                                ),
                              if (!kDebugMode)
                                const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              if (LoadingController.instance!.loadingText.value != "") ...[
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  LoadingController.instance!.loadingText.value,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        });
  }
}
