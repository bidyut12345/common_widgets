import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ScaleContainer extends StatefulWidget {
  const ScaleContainer({Key? key, required this.child, required this.appScale, this.isPadding = true, this.resizeToAvoidBottomInset = true}) : super(key: key);

  final Widget child;
  final double appScale;
  final bool isPadding;
  final bool resizeToAvoidBottomInset;
  @override
  State<ScaleContainer> createState() => _ScaleContainerState();
}

class _ScaleContainerState extends State<ScaleContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.appScale == 1.0
        ? widget.child
        : Container(
            child: kIsWeb
                ? widget.child
                : Padding(
                    padding: widget.resizeToAvoidBottomInset
                        ? EdgeInsets.only(
                            bottom:
                                widget.isPadding ? MediaQuery.of(context).viewInsets.bottom : MediaQuery.of(context).viewInsets.bottom * (1 - widget.appScale),
                          )
                        : EdgeInsets.zero,
                    child: FractionallySizedBox(
                      widthFactor: 1.0 / widget.appScale,
                      heightFactor: 1.0 / widget.appScale,
                      child: Transform.scale(
                        scale: widget.appScale,
                        child: LayoutBuilder(
                          builder: (layoutcontext, layoutconstraint) {
                            return widget.child;
                          },
                        ),
                      ),
                    ),
                  ),
          );
  }
}
