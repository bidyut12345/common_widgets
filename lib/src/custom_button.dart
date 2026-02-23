import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

enum IconTextAlignment { beforeText, afterText, aboveText, belowText }

enum ButtomStyleType { yes, ok, cancel, normal }

class CustomButton extends StatelessWidget {
  // static ButtonStyle Function(BuildContext context, ButtomStyleType buttonStyleType,
  //         {EdgeInsets? padding,
  //         Color? backcolor,
  //         Color? forecolor,
  //         Alignment? alignment,
  //         double? height,
  //         double? width,
  //         Widget? icon,
  //         double? iconTextGap,
  //         IconTextAlignment? iconAlignment,
  //         Color? focusColor,
  //         double? radius}) getButtonStyle =
  //     (context, buttonStyleType, {padding, backcolor, forecolor, alignment, height, width, icon, iconTextGap, iconAlignment, focusColor, radius}) {
  //   var isDarkMode = ThemeHelper.isDarkMode(context);
  //   switch (buttonStyleType) {
  //     case ButtomStyleType.yes:
  //       return ElevatedButton.styleFrom(
  //         padding: padding,
  //         backgroundColor:
  //             backcolor ?? (Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 53, 56, 82) : const Color.fromARGB(255, 128, 136, 214)),
  //         // minimumSize: const Size(double.infinity, 10),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 5)),
  //         alignment: alignment,
  //       ).copyWith(
  //         side: WidgetStateProperty.resolveWith((states) {
  //           if (states.contains(WidgetState.focused)) {
  //             return BorderSide(color: isDarkMode ? Colors.white : Colors.black, width: 2);
  //           }
  //           return null;
  //         }),
  //         shadowColor: WidgetStateProperty.resolveWith((states) {
  //           if (states.contains(WidgetState.focused)) {
  //             return isDarkMode ? focusColor ?? Colors.red : focusColor ?? Colors.red;
  //           }
  //           return null;
  //         }),
  //         elevation: WidgetStateProperty.resolveWith((states) {
  //           if (states.contains(WidgetState.focused)) {
  //             return 10.0;
  //           }
  //           return null;
  //         }),
  //       );
  //     case ButtomStyleType.ok:
  //     case ButtomStyleType.cancel:
  //     case ButtomStyleType.normal:
  //   }
  // };

  static ButtonStyle Function(BuildContext context) cancelButtonStyle = (context) {
    var isDarkMode_ = ThemeHelper.isDarkMode(context);
    return ElevatedButton.styleFrom(
      foregroundColor: isDarkMode_ ? Colors.white : Colors.black,
    );
  };

  final String text;
  final Widget? child;
  final VoidCallback onPressed;
  final double radius;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double fontSize;
  final Color? backcolor;
  final Color? forecolor;
  final Alignment alignment;
  final double? height;
  final double? width;

  final Widget? icon;
  final double iconTextGap;
  final IconTextAlignment iconAlignment;

  final Color? focusColor;

  // final Color color;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.child,
      this.radius = 15,
      this.margin = EdgeInsets.zero,
      this.padding,
      this.fontSize = 14,
      this.backcolor,
      this.forecolor,
      this.height,
      this.width,
      this.alignment = Alignment.center,
      this.icon,
      this.iconTextGap = 5,
      this.iconAlignment = IconTextAlignment.beforeText,
      this.focusColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ThemeHelper.isDarkMode(context);
    return Padding(
      padding: margin,
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: backcolor ??
                (Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 53, 56, 82) : const Color.fromARGB(255, 128, 136, 214)),
            // minimumSize: const Size(double.infinity, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            alignment: alignment,
          ).copyWith(
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return BorderSide(color: isDarkMode ? Colors.white : Colors.black, width: 2);
              }
              return null;
            }),
            shadowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return isDarkMode ? focusColor ?? Colors.white : focusColor ?? Colors.white;
              }
              return null;
            }),
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return 5.0;
              }
              return null;
            }),
          ),
          child: child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(
                      width: iconTextGap,
                    ),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      softWrap: true,
                      style: TextStyle(
                        color: forecolor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Color.fromARGB(255, 228, 228, 228)),
                        fontSize: fontSize,
                      ),
                      textAlign: [Alignment.topLeft, Alignment.bottomLeft, Alignment.centerLeft].contains(alignment)
                          ? TextAlign.left
                          : [Alignment.center, Alignment.topCenter, Alignment.bottomCenter].contains(alignment)
                              ? TextAlign.center
                              : TextAlign.right,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 5),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
