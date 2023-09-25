import 'package:flutter/material.dart';

import 'globals.dart';

class DropDownController extends TextEditingController {
  Function? onSelectedValueChanged;
  late Function(int index) selectItem;
  bool Function(dynamic)? isValid;
  dynamic _selectedValue;
  dynamic get selectedValue => _selectedValue;
  set selectedValue(dynamic value) {
    if (isValid != null) {
      if (isValid!(value)) {
        if (onSelectedValueChanged != null && _selectedValue != value) {
          _selectedValue = value;
          onSelectedValueChanged!();
        }
        _selectedValue = value;
      }
    } else {
      if (onSelectedValueChanged != null && _selectedValue != value) {
        _selectedValue = value;
        onSelectedValueChanged!();
      }
      _selectedValue = value;
    }
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.datasourc,
    required this.displayMember,
    required this.valueMember,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.wrongValues,
    this.required = true,
    this.onChanged,
  });

  final DropDownController controller;
  final List<Map<String, dynamic>> datasourc;
  final String displayMember;
  final String valueMember;
  final String labelText;
  final String hintText;
  final bool required;
  final List<String>? wrongValues;
  final Function(String value, String text)? onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String selectedValue = "";
  String selectedText = "";
  @override
  void initState() {
    super.initState();
    widget.controller.onSelectedValueChanged = () {
      loadvalue();
    };
    widget.controller.selectItem = (int index) {
      selectedValue = widget.datasourc[index][widget.valueMember]?.toString() ?? "";
      selectedText = widget.datasourc[index][widget.displayMember]?.toString() ?? "";
      widget.controller.text = selectedText;
      widget.controller.selectedValue = selectedValue;
      setState(() {});
    };
    widget.controller.isValid = (dynamic value) {
      List<Map> tmp =
          widget.datasourc.where((element) => element[widget.valueMember].toString() == value.toString()).toList();
      return tmp.isNotEmpty;
    };
    selectedValue = widget.datasourc.first[widget.valueMember]?.toString() ?? "";
    selectedText = widget.datasourc.first[widget.displayMember]?.toString() ?? "";
    if (widget.controller.text.isNotEmpty ||
        (widget.controller.selectedValue != null && widget.controller.selectedValue.isNotEmpty)) {
      loadvalue();
    } else {
      widget.controller.text = selectedText;
      widget.controller.selectedValue = selectedValue;
    }
    // widget.controller.addListener(() {
    //   if (widget.controller.text.isNotEmpty) {
    //     loadvalue();
    //   } else {
    //     widget.controller.text = selectedText;
    //     widget.controller.selectedValue = selectedValue;
    //   }
    //   setState(() {});
    // });
  }

  void loadvalue() {
    if (selectedValue != widget.controller.selectedValue && (widget.controller.selectedValue != null)) {
      try {
        List<Map> tmp = widget.datasourc
            .where((element) => element[widget.valueMember].toString() == widget.controller.selectedValue)
            .toList();
        if (tmp.isNotEmpty) {
          var rr = tmp.first[widget.valueMember];
          selectedValue = rr.toString();
          selectedText = tmp.first[widget.displayMember];
          if (widget.onChanged != null) {
            widget.onChanged!(selectedValue, selectedText);
          }
          setState(() {});
        }
      } catch (_) {}
    } else if (selectedText != widget.controller.text && widget.controller.text.isNotEmpty) {
      try {
        String tmp = widget.datasourc
                .where((element) => element[widget.displayMember].trim() == widget.controller.text.trim())
                .first[widget.valueMember] ??
            "";
        if (tmp.isNotEmpty) {
          selectedValue = tmp;
          selectedText = widget.controller.text;
          if (widget.onChanged != null) {
            widget.onChanged!(selectedValue, selectedText);
          }
          setState(() {});
        }
      } catch (_) {}
    }
  }

  FocusNode fc = FocusNode();
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
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Color.fromARGB(255, 139, 139, 139)),
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
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.1,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey,
              // color: Colors.red,
            ),
            gradient: LinearGradient(
                // colors: [Color.fromARGB(255, 235, 234, 234), Color.fromARGB(255, 182, 181, 181), Color.fromARGB(255, 167, 166, 166)],
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [Color.fromARGB(255, 12, 12, 12), Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)]
                    : [
                        Color.fromARGB(255, 238, 237, 237),
                        Color.fromARGB(255, 230, 229, 229),
                        Color.fromARGB(255, 226, 228, 236)
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: DropdownButtonFormField(
            focusNode: fc,
            focusColor: Colors.red,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
            ),

            // underline: Container(),
            items: widget.datasourc
                .map((e) => DropdownMenuItem(
                      value: e[widget.valueMember]?.toString() ?? "",
                      child: Text(e[widget.displayMember] ?? ""),
                    ))
                .toList(),
            validator: (value) {
              if (widget.required) {
                if ((value?.toString() ?? "").trim().isEmpty ||
                    (widget.wrongValues != null && widget.wrongValues!.contains(value))) {
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
            value: selectedValue,
            onChanged: (value) {
              selectedValue = value.toString();
              selectedText = widget.datasourc
                      .where((element) => element[widget.valueMember].toString() == selectedValue)
                      .first[widget.displayMember]
                      ?.toString() ??
                  "";
              widget.controller.text = selectedText;
              widget.controller.selectedValue = selectedValue;
              if (widget.onChanged != null) {
                widget.onChanged!(selectedValue, selectedText);
              }
              if (mounted) setState(() {});
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
