import 'package:common_widgets/src/input_formatters/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widget_config.dart';
import 'globals.dart';
import 'input_formatters/money_formatter.dart';
import 'package:flutter/services.dart';

class CustomTextbox extends StatefulWidget {
  const CustomTextbox({
    super.key,
    required this.controller,
    this.labelText = '',
    this.hintText = '',
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
    this.enabled = true,
    this.isUpperCase = false,
    this.isNumber = false,
    this.enableInteractiveSelection = false,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.fontSize = 12,
    this.onChanged,
    this.onFocused,
    this.onFocusleave,
    this.onSubmitted,
    this.focusNode,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardtype;
  final TextCapitalization capitalization;
  final bool required;
  final bool obsecureText;
  final bool multiline;
  final double endPadding;
  final bool readOnly;
  final TextAlign textAlign;
  final bool showLabel;
  final bool disableSuffixButtonClick;
  final bool autofocus;
  final bool enableInteractiveSelection;

  final bool isMoneyFormatter;
  final Widget? suffixIcon;
  final bool enabled;
  final bool isUpperCase;
  final bool isNumber;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double fontSize;
  final FocusNode? focusNode;
  final Function(String value)? onChanged;
  final Function(String value)? onFocusleave;
  final Function(String value)? onFocused;
  final Function(String value)? onSubmitted;
  @override
  State<CustomTextbox> createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  late FocusNode fc;
  @override
  void initState() {
    super.initState();
    fc = widget.focusNode ?? FocusNode();
    fc.addListener(() {
      if (fc.hasFocus) {
        if (widget.onFocused != null) widget.onFocused!(widget.controller.text);
      } else {
        if (widget.onFocusleave != null) widget.onFocusleave!(widget.controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: RichText(
              textAlign: TextAlign.left,
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
            ),
          ),
          const SizedBox(height: 3),
        ],
        TextFormField(
          autofocus: widget.autofocus,
          focusNode: fc,
          readOnly: widget.readOnly,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          controller: widget.controller,
          keyboardType: widget.multiline ? TextInputType.multiline : widget.keyboardtype,
          textInputAction: widget.multiline ? TextInputAction.newline : TextInputAction.next,
          obscureText: widget.obsecureText,
          onFieldSubmitted: widget.onSubmitted,
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
              color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 218, 218, 218) : Color.fromARGB(255, 71, 71, 71)),
          decoration: InputDecoration(
            // isDense: true,
            suffixIconConstraints: const BoxConstraints(maxHeight: 35, maxWidth: 45),

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
                                    ? DateFormat(CommonWidgetConfig.dateFormatString).parse(widget.controller.text)
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
                                  widget.controller.text = DateFormat(CommonWidgetConfig.dateFormatString).format(value);
                                }
                              });
                            },
                          ),
                        ),
                      )
                    : null),

            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
            fillColor: widget.enabled
                ? (widget.backgroundColor ?? (Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 69, 69, 69) : Colors.white))
                : Colors.grey,
            filled: true,
            isCollapsed: true,
            contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius ?? 5),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius ?? 5),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius ?? 5),
              ),
              borderSide: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 148, 148, 148),
              ),
            ),
          ),
        ),
        SizedBox(height: widget.endPadding),
      ],
    );
  }
}
