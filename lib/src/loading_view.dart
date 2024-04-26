import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_widgets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.child, this.fit = StackFit.loose}) : super(key: key);
  final Widget child;
  final StackFit fit;
  @override
  Widget build(BuildContext context) {
    LoadingController.instance = Provider.of<LoadingController>(context, listen: true);
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
                        if (LoadingController.instance!.loadingText != "") ...[
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            LoadingController.instance!.loadingText,
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
  }
}
