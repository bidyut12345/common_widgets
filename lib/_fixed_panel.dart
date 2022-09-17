import 'package:flutter/cupertino.dart';

class FixedPanelTop extends StatelessWidget {
  const FixedPanelTop({Key? key, this.topChild, required this.child, required this.topPanelHeight}) : super(key: key);
  final Widget? topChild;
  final Widget child;
  final double topPanelHeight;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: topChild == null ? 0 : topPanelHeight),
          child: child,
        ),
        topChild == null
            ? SizedBox(
                height: 1,
                child: Container(),
              )
            : SizedBox(
                height: topPanelHeight,
                child: topChild,
              ),
      ],
    );
  }
}

class FixedPanelBottom extends StatelessWidget {
  const FixedPanelBottom({Key? key, this.bottomChild, required this.child, required this.bottomPanelHeight}) : super(key: key);
  final Widget? bottomChild;
  final Widget child;
  final double bottomPanelHeight;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: bottomChild == null ? 0 : bottomPanelHeight),
          child: child,
        ),
        bottomChild == null
            ? SizedBox(
                height: 1,
                child: Container(),
              )
            : SizedBox(
                height: bottomPanelHeight,
                child: bottomChild,
              ),
      ],
    );
  }
}
