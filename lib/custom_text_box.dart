import 'package:flutter/material.dart';
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
    this.isMoneyFormatter = false,
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
  final bool isMoneyFormatter;

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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 86, 86, 86)),
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
        const SizedBox(height: 5),
        TextFormField(
          focusNode: fc,
          controller: widget.controller,
          keyboardType: widget.multiline ? TextInputType.multiline : widget.keyboardtype,
          textInputAction: widget.multiline ? TextInputAction.newline : TextInputAction.next,
          obscureText: widget.obsecureText,
          inputFormatters: widget.isMoneyFormatter ? [MoneyTextInputFormatter()] : null,
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
          style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 71, 71, 71)),
          maxLines: widget.multiline ? 4 : 1,
          minLines: widget.multiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 192, 192, 192)),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
