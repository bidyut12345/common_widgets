import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ScaleContainer extends StatefulWidget {
  const ScaleContainer(
      {Key? key,
      required this.child,
      required this.appScale,
      this.isPadding = true})
      : super(key: key);

  final Widget child;
  final double appScale;
  final bool isPadding;
  @override
  State<ScaleContainer> createState() => _ScaleContainerState();
}

class _ScaleContainerState extends State<ScaleContainer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: kIsWeb
          ? widget.child
          : LayoutBuilder(
              builder: (context, constraint) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: widget.isPadding
                        ? MediaQuery.of(context).viewInsets.bottom
                        : MediaQuery.of(context).viewInsets.bottom *
                            (1 - widget.appScale),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.appScale,
                    heightFactor: 1 / widget.appScale,
                    child: Transform.scale(
                      scale: widget.appScale,
                      child: LayoutBuilder(
                        builder: (layoutcontext, layoutconstraint) {
                          return widget.child;
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
