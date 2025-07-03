import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
import '../common_widgets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    LoadingController.instance ??= LoadingController(); //Provider.of<LoadingController>(context, listen: true);
    return ListenableBuilder(
        listenable: LoadingController.instance ?? LoadingController(),
        builder: (context, _) {
          return Stack(
            // fit: fit,
            fit: StackFit.passthrough,
            children: [
              child,
              LoadingController.instance!.isLoading
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        alignment: Alignment.center,
                        child: Card(
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          // clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (kDebugMode)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Loading...\n[Circularprogressbar is Hidden in DEBUG MODE]",
                                      textAlign: TextAlign.center,
                                    ),
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
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          );
        });
  }
}
