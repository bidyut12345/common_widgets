import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({
    Key? key,
    required this.title,
    required this.child,
    this.bottomChild,
    this.bottomChildHeight = 70,
  }) : super(key: key);
  final String title;
  final Widget child;
  final Widget? bottomChild;
  final double bottomChildHeight;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 57.0,
                  bottom: bottomChild != null ? bottomChildHeight : 0,
                ),
                child: Container(child: child),
              ),
              bottomChild != null
                  ? SizedBox(
                      height: bottomChildHeight,
                      child: bottomChild,
                    )
                  : SizedBox(height: 1, child: Container()),
            ],
          ),
          SizedBox(
            height: 57,
            child: AppBar(title: Text(title)),
          ),
        ],
      ),
    );
  }
}
