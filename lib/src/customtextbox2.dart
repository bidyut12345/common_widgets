import 'package:common_widgets/common_widgets.dart';
import 'package:common_widgets/src/input_formatters/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

import 'common_widget_config.dart';
import 'datetime_helper.dart';
import 'globals.dart';
import 'input_formatters/money_formatter.dart';
import 'package:flutter/services.dart';

class CustomTextbox2 extends StatefulWidget {
  const CustomTextbox2({
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
    this.foreColor,
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
    // this.alwaysShowFloatingLabel = true,
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
  // final bool alwaysShowFloatingLabel;
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
  final Color? foreColor;
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
  State<CustomTextbox2> createState() => _CustomTextbox2State();
}

class _CustomTextbox2State extends State<CustomTextbox2> {
  late FocusNode fcChild;
  // late FocusNode fcKeyboard;
  FocusNode fcParent = FocusNode();
  @override
  void initState() {
    super.initState();
    fcChild = widget.focusNode ?? FocusNode();
    fcChild.addListener(() {
      if (mounted) setState(() {});
    });
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

  PhysicalKeyboardKey? downKey;
  int lastFocus = 0;
  @override
  Widget build(BuildContext context) {
    var isDarkMode = ThemeHelper.isDarkMode(context);
    var label = widget.labelText == null
        ? null
        : RichText(
            textAlign: TextAlign.left,
            softWrap: false,
            text: TextSpan(
              style: TextStyle(
                fontSize: widget.showFloatingLabel ? 9 : 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? const Color.fromARGB(255, 209, 209, 209) : const Color.fromARGB(255, 86, 86, 86),
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
                    fontSize: widget.showFloatingLabel ? 10 : 14,
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
    Widget? suffixWidget = widget.suffixIcon ??
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
                        dt = widget.controller.text.trim() != '' ? parseDateTime(widget.controller.text, CommonWidgetConfig.dateFormatString) : DateTime.now();
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
            : null);

    Color bgColor = widget.readOnly
        ? (widget.backgroundColor ?? (isDarkMode ? const Color.fromARGB(255, 99, 99, 99) : const Color.fromARGB(255, 241, 241, 241)))
        : widget.enabled
            ? (widget.backgroundColor ?? (isDarkMode ? const Color.fromARGB(255, 69, 69, 69) : Colors.white))
            : Colors.grey;
    return Focus(
      // focusNode: fcParent,
      // descendantsAreTraversable: true,
      // skipTraversal: true,
      descendantsAreFocusable: widget.focusable,
      onFocusChange: (value) {
        if (value) {
          // print("Got focus");
          // print(DateTime.now().millisecondsSinceEpoch);
          if ((DateTime.now().millisecondsSinceEpoch - lastFocus) > 500) {
            lastFocus = DateTime.now().millisecondsSinceEpoch;
            if (widget.onFocused != null) {
              widget.onFocused!(widget.controller.text, fcChild);
            }
          }

          // fcChild.nextFocus();
        } else {
          if (widget.onFocusleave != null) {
            widget.onFocusleave!(widget.controller.text, fcChild, widget.controller);
          }
        }
      },
      onKeyEvent: (node, value) {
        // if (value is KeyUpEvent) {
        //   if (value.physicalKey == PhysicalKeyboardKey.enter || value.physicalKey == PhysicalKeyboardKey.numpadEnter) {
        //     if (widget.onSubmitted != null) {
        //       widget.onSubmitted!(widget.controller.text, fcChild);
        //       return KeyEventResult.handled;
        //     }
        //   }
        // }
        if (value is KeyDownEvent) {
          if (value.physicalKey == PhysicalKeyboardKey.enter || value.physicalKey == PhysicalKeyboardKey.numpadEnter) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(widget.controller.text, fcChild);
              return KeyEventResult.handled;
            }
          }
          downKey = value.physicalKey;
          if (widget.keyPress != null) return widget.keyPress!(value.physicalKey, fcChild);
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius ?? 5),
                    ),
                    border: fcChild.hasFocus
                        ? Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 247, 41, 41),
                          )
                        : Border.all(
                            width: 1,
                            color: isDarkMode ? Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 126, 126, 126),
                          ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) Container(padding: const EdgeInsets.only(left: 5), child: widget.prefixIcon!),
                      Expanded(
                        child: TextFormField(
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
                            // if (widget.onSubmitted != null) widget.onSubmitted!(value, fcChild);
                          },
                          inputFormatters: [
                            if (widget.isMoneyFormatter) MoneyTextInputFormatter(),
                            if (widget.isUpperCase) UpperCaseTextFormatter(),
                            // if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
                            if (widget.isNumber) FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                            if (widget.isNumber)
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.text.isEmpty || double.tryParse(newValue.text) != null ? newValue : oldValue),
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
                                  fcChild.requestFocus();
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
                              color: widget.foreColor ?? (isDarkMode ? const Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 71, 71, 71)),
                              fontWeight: widget.fontWeight),
                          decoration: InputDecoration(
                            isDense: widget.compact,
                            suffixIconConstraints: widget.keyboardtype == TextInputType.datetime ? const BoxConstraints(maxHeight: 35, maxWidth: 45) : null,
                            // label: widget.showFloatingLabel ? label : null,
                            // floatingLabelBehavior: widget.alwaysShowFloatingLabel ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // prefixIcon: widget.prefixIcon,
                            // suffixIcon: suffixWidget,
                            hintText: widget.hintText,
                            hintStyle: const TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
                            fillColor: Colors.transparent,
                            filled: true,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            isCollapsed: true,
                            contentPadding:
                                widget.compact ? const EdgeInsets.all(8) : widget.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 11),

                            border: OutlineInputBorder(
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(widget.borderRadius ?? 5),
                              // ),
                              borderSide: BorderSide(
                                width: 0.01,
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(widget.borderRadius ?? 5),
                              // ),
                              borderSide: BorderSide(
                                width: 0.01,
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(widget.borderRadius ?? 5),
                              // ),
                              borderSide: BorderSide(
                                width: 0.01,
                                color: Colors.transparent,
                              ),
                            ),
                            // border: InputBorder.none,
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            // enabledBorder: InputBorder.none,
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(
                            //     Radius.circular(widget.borderRadius ?? 5),
                            //   ),
                            //   borderSide: BorderSide(
                            //     width: 1,
                            //     color: isDarkMode ? const Color.fromARGB(255, 218, 218, 218) : const Color.fromARGB(255, 177, 177, 177),
                            //   ),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(
                            //     Radius.circular(widget.borderRadius ?? 5),
                            //   ),
                            //   borderSide: const BorderSide(
                            //     width: 1,
                            //     color: Color.fromARGB(255, 247, 41, 41),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                      if (suffixWidget != null) suffixWidget,
                    ],
                  ),
                ),
              ),
              if (widget.showFloatingLabel && label != null) ...[
                Positioned(
                  top: -7,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Stack(
                      alignment: AlignmentGeometry.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Container(
                              color: bgColor,
                              height: 1,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: label,
                                  ))),
                        ),
                        Container(child: Padding(padding: const EdgeInsets.only(left: 5.0, right: 5.0), child: label)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (!widget.compact) SizedBox(height: widget.endPadding),
        ],
      ),
    );
  }
}
