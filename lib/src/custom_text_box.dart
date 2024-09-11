import 'package:common_widgets/src/input_formatters/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_widget_config.dart';
import 'globals.dart';
import 'input_formatters/money_formatter.dart';

class CustomTextbox extends StatefulWidget {
  const CustomTextbox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardtype = TextInputType.text,
    this.capitalization = TextCapitalization.words,
    this.required = true,
    this.obsecureText = false,
    this.multiline = false,
    this.endPadding = 5,
    this.readOnly = false,
    this.autoFocus = false,
    this.showLabel = true,
    this.textAlign = TextAlign.left,
    this.disableSuffixButtonClick = false,
    this.isMoneyFormatter = false,
    this.suffixIcon,
    this.enabled = true,
    this.isUpperCase = false,

    // required this.onChanged,
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
  final bool autoFocus;
  final bool showLabel;
  final bool disableSuffixButtonClick;
  final bool isMoneyFormatter;
  final Widget? suffixIcon;
  final bool enabled;
  final bool isUpperCase;
  @override
  State<CustomTextbox> createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  FocusNode fc = FocusNode();

  // final void Function(String) onChanged;
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
          autofocus: widget.autoFocus,
          focusNode: fc,
          readOnly: widget.readOnly,
          controller: widget.controller,
          keyboardType: widget.multiline ? TextInputType.multiline : widget.keyboardtype,
          textInputAction: widget.multiline ? TextInputAction.newline : TextInputAction.next,
          obscureText: widget.obsecureText,
          inputFormatters: [
            if (widget.isMoneyFormatter) MoneyTextInputFormatter(),
            if (widget.isUpperCase) UpperCaseTextFormatter(),
          ],
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
              fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 218, 218, 218) : Color.fromARGB(255, 71, 71, 71)),
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

                              showDatePicker(
                                initialEntryMode: DatePickerEntryMode.calendarOnly,
                                context: context,
                                currentDate: DateTime.now(),
                                useRootNavigator: false,
                                initialDate: widget.controller.text.trim() != ''
                                    ? (DateFormat(CommonWidgetConfig.dateFormatString).tryParse(widget.controller.text) ?? DateTime.now())
                                    : DateTime.now(),
                                firstDate: DateTime(0000),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Column(
                                    children: [
                                      child ?? Container(),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, DateTime.now());
                                          },
                                          child: const Text("Now"))
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
                ? Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 69, 69, 69)
                    : Colors.white
                : Colors.grey,
            filled: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
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
