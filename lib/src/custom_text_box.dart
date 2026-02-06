import 'package:common_widgets/src/input_formatters/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

import 'common_widget_config.dart';
import 'datetime_helper.dart';
import 'globals.dart';
import 'input_formatters/money_formatter.dart';
import 'package:flutter/services.dart';

class CustomTextbox extends StatefulWidget {
  const CustomTextbox({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.keyboardtype = TextInputType.text,
    this.capitalization = TextCapitalization.words,
    this.required = true,
    this.obsecureText = false,
    this.multiline = false,
    this.endPadding = 5,
    this.readOnly = false,
    this.autofocus = false,
    this.showLabel = true,
    this.textAlign = TextAlign.left,
    this.disableSuffixButtonClick = false,
    this.isMoneyFormatter = false,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.isUpperCase = false,
    this.isNumber = false,
    this.enableInteractiveSelection = true,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.onChanged,
    this.onFocused,
    this.onFocusleave,
    this.onSubmitted,
    this.focusNode,
    this.onTap,
    this.showFloatingLabel = false,
    this.alwaysShowFloatingLabel = true,
    this.focusable = true,
    this.compact = false,
    this.keyPress,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardtype;
  final TextCapitalization capitalization;
  final bool required;
  final bool obsecureText;
  final bool multiline;
  final double endPadding;
  final bool readOnly;
  final TextAlign textAlign;
  final bool showLabel;
  final bool showFloatingLabel;
  final bool alwaysShowFloatingLabel;
  final bool disableSuffixButtonClick;
  final bool autofocus;
  final bool focusable;
  final bool enableInteractiveSelection;

  final bool isMoneyFormatter;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isUpperCase;
  final bool isNumber;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final FocusNode? focusNode;
  final bool compact;
  final Function(String value)? onChanged;
  final Function(String value, FocusNode fn, TextEditingController tc)? onFocusleave;
  final Function(String value, FocusNode fn)? onFocused;
  final Function(String value, FocusNode fn)? onSubmitted;
  final Function(String value)? onTap;
  final KeyEventResult Function(
    PhysicalKeyboardKey keyCode,
    FocusNode fn,
  )? keyPress;
  @override
  State<CustomTextbox> createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  late FocusNode fc;
  // late FocusNode fcKeyboard;
  @override
  void initState() {
    super.initState();
    fc = widget.focusNode ?? FocusNode();
    // fcKeyboard = FocusNode();
    // fc.addListener(() {
    //   if (fc.hasFocus) {
    //     // if (fc.hasFocus && !widget.focusable) {
    //     //   fc.nextFocus();
    //     // }
    //     if ((DateTime.now().millisecondsSinceEpoch - lastFocus) > 500) {
    //       lastFocus = DateTime.now().millisecondsSinceEpoch;
    //       if (widget.onFocused != null) {
    //         widget.onFocused!(widget.controller.text, fc);
    //       }
    //     }
    //   } else {
    //     if (widget.onFocusleave != null) widget.onFocusleave!(widget.controller.text, fc);
    //   }
    // });
    // fcKeyboard.addListener(() {
    //   if (fcKeyboard.hasFocus) {
    //     fcKeyboard.nextFocus();
    //     // print("got focus keyboard ${widget.labelText}");
    //   }
    // });
  }

  FocusNode fcChild = FocusNode();
  PhysicalKeyboardKey? downKey;
  int lastFocus = 0;
  @override
  Widget build(BuildContext context) {
    var label = widget.labelText == null
        ? null
        : RichText(
            textAlign: TextAlign.left,
            softWrap: false,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 209, 209, 209) : const Color.fromARGB(255, 86, 86, 86),
                // color: Color.fromARGB(255, 86, 86, 86),
              ),
              children: [
                TextSpan(
                  text: widget.labelText,
                ),
                TextSpan(
                  text: widget.required ? " *" : "",
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          );
    // focusNode: fc,
    // onKeyEvent: (value) {
    //   if (value is KeyDownEvent) {
    //     downKey = value.physicalKey;
    //   }
    //   if (value is KeyUpEvent && downKey == value.physicalKey) {
    //     if (widget.keyPress != null) widget.keyPress!(value.physicalKey, fc);
    //   }
    // },
    return Focus(
      focusNode: fc,
      descendantsAreTraversable: true,
      skipTraversal: true,
      descendantsAreFocusable: widget.focusable,
      onFocusChange: (value) {
        if (value) {
          // print("Got focus");
          // print(DateTime.now().millisecondsSinceEpoch);
          if ((DateTime.now().millisecondsSinceEpoch - lastFocus) > 500) {
            lastFocus = DateTime.now().millisecondsSinceEpoch;
            if (widget.onFocused != null) {
              widget.onFocused!(widget.controller.text, fc);
            }
          }

          // fcChild.nextFocus();
        } else {
          if (widget.onFocusleave != null) {
            widget.onFocusleave!(widget.controller.text, fc, widget.controller);
          }
        }
      },
      onKeyEvent: (node, value) {
        if (value is KeyDownEvent) {
          downKey = value.physicalKey;
          if (widget.keyPress != null) return widget.keyPress!(value.physicalKey, fc);
        }
        // if (value is KeyUpEvent && downKey == value.physicalKey) {}
        return KeyEventResult.ignored;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: label,
            ),
            if (!widget.compact) const SizedBox(height: 3),
          ],
          // EditableText(
          //   style: TextStyle(),
          //   controller: widget.controller,
          //   cursorColor: Colors.black,
          //   focusNode: fcKeyboard,
          //   backgroundCursorColor: Colors.red,
          // ),
          TextFormField(
            autofocus: widget.autofocus,
            focusNode: fcChild,
            readOnly: widget.readOnly,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            controller: widget.controller,
            keyboardType: widget.multiline ? TextInputType.multiline : widget.keyboardtype,
            textInputAction: widget.multiline
                ? TextInputAction.newline
                : widget.keyPress == null
                    ? TextInputAction.next
                    : TextInputAction.none,
            obscureText: widget.obsecureText,
            onFieldSubmitted: (value) {
              if (widget.onSubmitted != null) widget.onSubmitted!(value, fc);
            },
            inputFormatters: [
              if (widget.isMoneyFormatter) MoneyTextInputFormatter(),
              if (widget.isUpperCase) UpperCaseTextFormatter(),
              // if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
              if (widget.isNumber) FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              if (widget.isNumber)
                TextInputFormatter.withFunction((oldValue, newValue) => newValue.text.isEmpty || double.tryParse(newValue.text) != null ? newValue : oldValue),
            ],
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value);
            },
            onTap: () {
              if (widget.onTap != null) widget.onTap!(widget.controller.text);
            },
            minLines: widget.multiline ? 2 : 1,
            maxLines: widget.multiline ? 5 : 1,
            textAlign: widget.textAlign,
            validator: (value) {
              if (widget.required) {
                if ((value ?? "").trim().isEmpty) {
                  if (!focusRequested) {
                    fc.requestFocus();
                    focusRequested = true;
                  }
                  return "** required field";
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
            textCapitalization: widget.capitalization,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 71, 71, 71),
                fontWeight: widget.fontWeight),
            decoration: InputDecoration(
              isDense: widget.compact,
              suffixIconConstraints: widget.keyboardtype == TextInputType.datetime ? const BoxConstraints(maxHeight: 35, maxWidth: 45) : null,
              label: widget.showFloatingLabel ? label : null,
              floatingLabelBehavior: widget.alwaysShowFloatingLabel ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon ??
                  (widget.keyboardtype == TextInputType.datetime
                      ? Material(
                          color: Colors.transparent,
                          child: Center(
                            child: IconButton(
                              enableFeedback: !widget.disableSuffixButtonClick,
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                                size: 20,
                              ),
                              style: IconButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                              onPressed: () {
                                if (widget.disableSuffixButtonClick) return;
                                var dt = DateTime.now();
                                try {
                                  dt = widget.controller.text.trim() != ''
                                      ? parseDateTime(widget.controller.text, CommonWidgetConfig.dateFormatString)
                                      : DateTime.now();
                                } catch (e) {}
                                showDatePicker(
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                  context: context,
                                  currentDate: DateTime.now(),
                                  useRootNavigator: false,
                                  initialDate: dt,
                                  firstDate: DateTime(0000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        // DatePickerDialog(
                                        //   firstDate: DateTime(0000),
                                        //   lastDate: DateTime(2100),
                                        // ),
                                        child ?? Container(),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, DateTime.now());
                                          },
                                          child: const Text("Now"),
                                        )
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    widget.controller.text = formatDateTime(value, CommonWidgetConfig.dateFormatString);
                                    if (widget.onChanged != null) widget.onChanged!(widget.controller.text);
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      : null),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
              fillColor: widget.readOnly
                  ? (widget.backgroundColor ??
                      (Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 99, 99, 99) : const Color.fromARGB(255, 241, 241, 241)))
                  : widget.enabled
                      ? (widget.backgroundColor ?? (Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 69, 69, 69) : Colors.white))
                      : Colors.grey,
              filled: true,
              isCollapsed: true,
              contentPadding: widget.compact ? const EdgeInsets.all(8) : widget.padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 177, 177, 177),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 126, 126, 126),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 5),
                ),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 247, 41, 41),
                ),
              ),
            ),
          ),
          if (!widget.compact) SizedBox(height: widget.endPadding),
        ],
      ),
    );
  }
}
