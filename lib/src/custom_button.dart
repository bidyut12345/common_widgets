import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
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
  // final Color color;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.radius = 15,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.fontSize = 14,
    this.backcolor,
    this.forecolor,
    this.height,
    this.width,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor:
                backcolor ?? (Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 53, 56, 82) : const Color.fromARGB(255, 128, 136, 214)),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            alignment: alignment,
          ),
          child: Text(
            text,
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
      ),
    );
  }
}
