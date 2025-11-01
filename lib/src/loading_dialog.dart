import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async/async.dart';

Future<dynamic> showLoadingDialog({
  required BuildContext context,
  required Future Function(BuildContext context, Function(String loadingText) setString) onLoading,
  bool cancellable = false,
  String initialText = "",
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (contextDlg) {
      return AlertDialog(content: LoadingDialogWidget(onLoading: onLoading, cancellable: cancellable, initialText: initialText));
    },
  );
}

class LoadingDialogWidget extends StatefulWidget {
  const LoadingDialogWidget({super.key, required this.onLoading, required this.cancellable, required this.initialText});

  final Future Function(BuildContext context, Function(String loadingText) setString) onLoading;
  final bool cancellable;
  final String initialText;
  @override
  State<LoadingDialogWidget> createState() => _LoadingDialogWidgetState();
}

class _LoadingDialogWidgetState extends State<LoadingDialogWidget> {
  String loadingText = "";
  late CancelableOperation cancelableOperation;
  @override
  void initState() {
    loadingText = widget.initialText;
    super.initState();
    Timer.run(() async {
      try {
        // var data = await widget.onLoading((String text) {
        //   setState(() {
        //     loadingText = text;
        //   });
        // });

        cancelableOperation = CancelableOperation.fromFuture(
          widget.onLoading(this.context, (String text) {
            setState(() {
              loadingText = text;
            });
          }),
          onCancel: () {
            print("cancelled");
            // msgBoxOkOnly(context: this.context, message: 'Task canceled', title: 'Error');
            // if (mounted) Navigator.pop(this.context, null);
          },
        );
        final result = await cancelableOperation.valueOrCancellation('CANCELLED');
        if (result == 'CANCELLED') {
          print("cancelled $result");
          if (mounted) Navigator.pop(context, result);
        } else {
          print("done $result");
          if (mounted) Navigator.pop(context, result);
        }
      } catch (_) {
        if (mounted) Navigator.pop(context, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 300,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Center(child: CircularProgressIndicator())),
          if (loadingText.isNotEmpty) SizedBox(height: 10),
          if (loadingText.isNotEmpty) Text(loadingText),
          if (widget.cancellable) SizedBox(height: 10),
          if (widget.cancellable)
            ElevatedButton(
              onPressed: () {
                cancelableOperation.cancel();
              },
              child: Text("CANCEL"),
            ),
        ],
      ),
    );
  }
}
