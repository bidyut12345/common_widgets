import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    required this.datasource,
    required this.displayMember,
    required this.valueMember,
    required this.labelText,
    this.controller,
    this.required = true,
    this.autoFocus = false,
    this.endPadding = 5.0,
    this.onChanged,
    this.defaultValue,
    this.showLabel = true,
    this.wrongValues,
    this.multiSelect = false,
  });

  final DropDownController? controller;
  final List<Map<String, dynamic>> datasource;
  final String displayMember;
  final String valueMember;
  final String labelText;
  final bool required;
  final List<String>? wrongValues;
  final bool autoFocus;
  final String? defaultValue;
  final bool showLabel;
  final double endPadding;
  final bool multiSelect;

  final Function(String value, String text)? onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  FocusNode fc = FocusNode();
  String selectedValue = "";
  String selectedText = "";
  List<String> selectedItems = [];
  @override
  void initState() {
    super.initState();
    fc.addListener(() {
      setState(() {});
    });
    widget.controller?.onSelectedValueChanged = () {
      loadvalue();
    };
    widget.controller?.selectItem = (int index) {
      selectedValue = widget.datasource[index][widget.valueMember]?.toString() ?? "";
      selectedText = widget.datasource[index][widget.displayMember]?.toString() ?? "";
      widget.controller?.text = selectedText;
      widget.controller?.selectedValue = selectedValue;
      setState(() {});
    };
    widget.controller?.isValid = (dynamic value) {
      List<Map> tmp = widget.datasource.where((element) => element[widget.valueMember].toString() == value.toString()).toList();
      return tmp.isNotEmpty;
    };
    selectedValue = widget.datasource.first[widget.valueMember]?.toString() ?? "";
    selectedText = widget.datasource.first[widget.displayMember]?.toString() ?? "";
    if (widget.controller != null) {
      if (widget.controller!.text.isNotEmpty || (widget.controller!.selectedValue != null && widget.controller!.selectedValue.toString().isNotEmpty)) {
        loadvalue();
      } else {
        widget.controller!.text = selectedText;
        widget.controller!.selectedValue = selectedValue;
      }

      if (widget.onChanged == null) {
        // widget.controller?.addListener(() {
        //   if (widget.controller!.text.isNotEmpty) {
        //     loadvalue();
        //   } else {
        //     widget.controller!.text = selectedText;
        //     widget.controller!.selectedValue = selectedValue;
        //   }
        //   setState(() {});
        // });
      }
    }
    if (widget.defaultValue != null) {
      List<Map> tmp = widget.datasource.where((element) => element[widget.valueMember].toString() == widget.defaultValue.toString()).toList();
      if (tmp.isNotEmpty) {
        selectedValue = widget.defaultValue!;
        selectedText = tmp.first[widget.displayMember] ?? "";
      }
    }
  }

  void loadvalue() {
    if (widget.controller != null) {
      {
        if (selectedValue != widget.controller!.selectedValue && (widget.controller!.selectedValue != null)) {
          try {
            List<Map> tmp = widget.datasource.where((element) => element[widget.valueMember].toString() == widget.controller!.selectedValue).toList();
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
        } else if (selectedText != widget.controller!.text && widget.controller!.text.isNotEmpty) {
          try {
            String tmp = widget.datasource
                    .where((element) => element[widget.displayMember].trim() == widget.controller!.text.trim())
                    .first[widget.valueMember]
                    ?.toString() ??
                "";
            if (tmp.isNotEmpty) {
              selectedValue = tmp;
              selectedText = widget.controller!.text;
              if (widget.onChanged != null) {
                widget.onChanged!(selectedValue, selectedText);
              }
              setState(() {});
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color borderColor = Theme.of(context).brightness == Brightness.dark
    //     ? Color.fromARGB(255, 209, 209, 209)
    //     : Color.fromARGB(255, 86, 86, 86);
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
          const SizedBox(height: 3)
        ],
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: fc.hasFocus
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Color.fromARGB(255, 146, 146, 146)
                      : const Color.fromARGB(255, 148, 148, 148)
                  : Colors.transparent,
            ),
            // gradient: const LinearGradient(
            //     colors: [Color.fromARGB(255, 235, 234, 234), Color.fromARGB(255, 182, 181, 181), Color.fromARGB(255, 167, 166, 166)],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter),
            gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color.fromARGB(255, 56, 56, 56), const Color.fromARGB(255, 73, 73, 73), const Color.fromARGB(255, 87, 87, 87)]
                    : [const Color.fromARGB(255, 238, 237, 237), const Color.fromARGB(255, 230, 229, 229), const Color.fromARGB(255, 226, 228, 236)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: DropdownButtonFormField(
            // height: 100,
            // icon: Icon(Icons.downhill_skiing),
            focusNode: fc,
            isExpanded: true,
            isDense: true,
            autofocus: widget.autoFocus,
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              isCollapsed: true,
              // contentPadding: EdgeInsets.zero,
            ),
            padding: EdgeInsets.symmetric(vertical: 7.5),

            validator: (value) {
              if (widget.required) {
                if ((value?.toString() ?? "").trim().isEmpty || (widget.wrongValues != null && widget.wrongValues!.contains(value))) {
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
            // underline: Container(),
            items: widget.datasource
                .map((e) => DropdownMenuItem(
                      // onTap: () {
                      //   bool value = !selectedItems.contains(e[widget.valueMember]?.toString() ?? "");
                      //   selectedItems.removeWhere((element) => element == (e[widget.valueMember]?.toString() ?? ""));
                      //   if (value) {
                      //     selectedItems.add(e[widget.valueMember]?.toString() ?? "");
                      //   }
                      //   print(selectedItems);
                      // },
                      value: e[widget.valueMember]?.toString() ?? "",
                      child: Row(
                        children: [
                          if (widget.multiSelect)
                            StatefulBuilder(builder: (context, setState2) {
                              return Checkbox(
                                  value: selectedItems.contains(e[widget.valueMember]?.toString() ?? ""),
                                  onChanged: (value) {
                                    selectedItems.removeWhere((element) => element == (e[widget.valueMember]?.toString() ?? ""));
                                    if (value ?? false) {
                                      selectedItems.add(e[widget.valueMember]?.toString() ?? "");
                                    }
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(selectedValue, selectedText);
                                    }
                                    setState2(() {});
                                    print(selectedItems);
                                  });
                            }),
                          Expanded(
                            child: Text(
                              e[widget.displayMember]?.toString() ?? "",
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: widget.multiSelect
                ? widget.datasource.first[widget.valueMember]?.toString() ?? ""
                : widget.datasource.where((element) => element[widget.valueMember].toString() == selectedValue).isEmpty
                    ? widget.datasource.first[widget.valueMember]?.toString() ?? ""
                    : selectedValue,

            onChanged: (value) {
              if (!widget.multiSelect) {
                selectedValue = value.toString();
                selectedText =
                    widget.datasource.where((element) => element[widget.valueMember].toString() == selectedValue).first[widget.displayMember]?.toString() ?? "";

                if (widget.controller != null) {
                  if (selectedValue != widget.controller!.selectedValue && widget.controller!.selectedValue.isNotEmpty) {
                    widget.controller!.text = selectedText;
                    widget.controller!.selectedValue = selectedValue;
                  }
                }
                if (mounted) setState(() {});
              }
              if (widget.onChanged != null) {
                widget.onChanged!(selectedValue, selectedText);
              }
            },
          ),
        ),
        SizedBox(height: widget.endPadding),
      ],
    );
  }
}
