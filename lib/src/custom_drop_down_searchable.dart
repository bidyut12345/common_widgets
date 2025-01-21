import 'dart:async';
import 'dart:math';

import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CustomDropDownSearchable extends StatefulWidget {
  const CustomDropDownSearchable({
    required GlobalKey super.key,
    this.controller,
    required this.dataSource,
    required this.valueMember,
    required this.displayMember,
    this.displayMemberBuilder,
    this.selectedItemBuilder,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.fontSize = 16,
    this.topWidget,
    this.selectString = "--SELECT--",
    this.searchBuilder,
    this.isMobileView = false,
    this.selectionChanged,
    this.newTextItem = false,
  });
//
  final DropDownController? controller;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double fontSize;
  final Widget Function(Map<String, dynamic> row)? displayMemberBuilder;
  final Widget Function(Map<String, dynamic> row)? selectedItemBuilder;
  final String valueMember;
  final String displayMember;
  final Widget Function(BuildContext context)? topWidget;
  final List<Map<String, dynamic>> dataSource;
  final List<Map<String, dynamic>> Function(String searchText)? searchBuilder;
  final Function(Map<String, dynamic>? row, dynamic value, String text)? selectionChanged;
  final String selectString;
  final bool isMobileView;
  final bool newTextItem;
  @override
  State<CustomDropDownSearchable> createState() => _CustomDropDownSearchableState();
}

class _CustomDropDownSearchableState extends State<CustomDropDownSearchable> {
  ValueNotifier<Rect?> itemRect = ValueNotifier(null);
  var isDialogShown = false;
  List<Map<String, dynamic>> filteredDataSource = [];
  late TextEditingController textController;
  final itemsKeyboardListenerFocusNode = FocusNode();
  final mainKeyBoardListenerFocusNode = FocusNode();
  final mainFn = FocusNode();

  bool isDialogClosed = false;
  bool isFocused = false;
  int selectedIndex = 0;
  dynamic selectedValue;
  String selectedText = "";
  Map<String, dynamic>? selectedItem;
  String keystr = "";
  @override
  void initState() {
    super.initState();
    keystr = Random().nextInt(10000000).toString();
  }

  @override
  Widget build(BuildContext context) {
    var tt = TextPainter(text: TextSpan(text: "Ty", style: TextStyle(fontSize: widget.fontSize)), textDirection: TextDirection.ltr)..layout();
    var padd = widget.padding ??
        (widget.isMobileView ? const EdgeInsets.symmetric(horizontal: 2, vertical: 12) : const EdgeInsets.symmetric(horizontal: 2, vertical: 7));

    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      child: KeyboardListener(
        focusNode: mainKeyBoardListenerFocusNode,
        onKeyEvent: (value) {
          if (value is KeyUpEvent) {
            print(value);
            if (value.physicalKey == PhysicalKeyboardKey.tab) {
              mainFn.nextFocus();
            } else if (value.physicalKey != PhysicalKeyboardKey.escape) {
              openWindow();
            }
          }
        },
        child: Focus(
          focusNode: mainFn,
          onFocusChange: (value) {
            if (value) {
              if (!isDialogClosed) {
                openWindow();
              }
            }
            isDialogClosed = false;
            setState(() {
              isFocused = value;
            });
          },
          child: Container(
            padding: EdgeInsets.only(
              left: padd.left,
              right: padd.right,
              top: max(padd.top - 4, 0),
              bottom: max(padd.bottom - 2, 0),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 69, 69, 69) : Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              border: Border.all(
                width: isFocused ? 1 : 0.1,
                color: Colors.grey,
              ),
            ),
            child: Container(
              // scrollDirection: Axis.horizontal,
              height: tt.height,
              constraints: BoxConstraints(maxHeight: tt.height),
              alignment: Alignment.centerLeft,
              child: selectedItem == null && widget.newTextItem && selectedText.isNotEmpty
                  ? Text(selectedText, style: TextStyle(fontSize: widget.fontSize))
                  : selectedItem == null
                      ? Text(widget.selectString, style: TextStyle(fontSize: widget.fontSize))
                      : widget.selectedItemBuilder != null
                          ? widget.selectedItemBuilder!(selectedItem!)
                          : widget.displayMemberBuilder != null
                              ? widget.displayMemberBuilder!(selectedItem!)
                              : Text(selectedText, style: TextStyle(fontSize: widget.fontSize)),
            ),
          ),
        ),
      ),
      onTap: () {
        openWindow();
      },
    );
  }

  bool isWindowOpened = false;
  openWindow() {
    if (isWindowOpened) return;
    isWindowOpened = true;
    // await compute((message) => message.requestFocus(), mainFn);
    mainFn.requestFocus();
    var sc = ItemScrollController();
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    itemRect.value = itemBox.localToGlobal(Offset.zero, ancestor: Navigator.of(context).context.findRenderObject()) &
        Size(itemBox.size.width, (Navigator.of(context).context.findRenderObject()! as RenderBox).size.height); //(-98, 90)
    isDialogShown = true;
    String lastSearchText = "";
    filteredDataSource = widget.dataSource;

    var padd = widget.padding ??
        (widget.isMobileView ? const EdgeInsets.symmetric(horizontal: 2, vertical: 12) : const EdgeInsets.symmetric(horizontal: 2, vertical: 7));
    if (selectedValue != null) {
      selectedIndex = filteredDataSource.indexWhere((element) => element[widget.valueMember] == selectedValue);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (sc.isAttached) {
          sc.scrollTo(
            index: selectedIndex,
            duration: const Duration(
              milliseconds: 100,
            ),
          );
        }
        // var kk = GlobalObjectKey(selectedIndex);
        // if (kk.currentContext != null) {
        //   // Scrollable.recommendDeferredLoadingForContext(context);
        //   Scrollable.ensureVisible(
        //     kk.currentContext!,
        //     alignment: 0.5,
        //     duration: const Duration(
        //       milliseconds: 500,
        //     ),
        //     // alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        //   );
        // }
      });
    }
    bool tabPress = false;

    showDialog(
      context: context,
      useRootNavigator: false,
      useSafeArea: true,
      // barrierDismissible: false,
      builder: (contextdlg) {
        textController = TextEditingController();
        search() {
          if (lastSearchText != textController.text) {
            lastSearchText = textController.text;
            selectedIndex = 0;
            if (textController.text.isEmpty) {
              filteredDataSource = widget.dataSource;
            } else {
              if (widget.searchBuilder == null) {
                filteredDataSource = widget.dataSource
                    .where((element) => element[widget.displayMember].toString().toLowerCase().contains(textController.text.trim().toLowerCase()))
                    .toList();
              } else {
                filteredDataSource = widget.searchBuilder!(textController.text);
              }
            }
          }
        }

        if (widget.newTextItem && selectedItem == null) {
          lastSearchText = "";
          textController.text = selectedText;
          search();
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: LayoutBuilder(
            builder: (contextdilglay, cons) {
              if (isDialogShown) {
                final itemBox1 = context.findRenderObject();
                if (itemBox1 != null) {
                  var itemBox = itemBox1 as RenderBox;
                  Timer.run(
                    () {
                      itemRect.value = itemBox.localToGlobal(
                            Offset.zero,
                            ancestor: Navigator.of(context).context.findRenderObject(),
                          ) &
                          Size(
                            itemBox.size.width,
                            (Navigator.of(context).context.findRenderObject()! as RenderBox).size.height,
                          );
                    },
                  );
                }
              }
              return StatefulBuilder(
                builder: (BuildContext contextstf, setState) {
                  var dialogContent = KeyboardListener(
                    focusNode: itemsKeyboardListenerFocusNode,
                    onKeyEvent: (value) {
                      if (value is KeyDownEvent) {
                        if (value.physicalKey == PhysicalKeyboardKey.tab) {
                          tabPress = true;
                        } else {
                          tabPress = false;
                        }
                      }
                      if (value is KeyUpEvent) {
                        if (value.physicalKey == PhysicalKeyboardKey.tab && tabPress) {
                          Navigator.pop(contextdlg);
                        } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                          Navigator.pop(contextdlg);
                        } else if (value.physicalKey == PhysicalKeyboardKey.arrowDown) {
                          selectedIndex += 1;
                          if (selectedIndex >= filteredDataSource.length) {
                            selectedIndex = filteredDataSource.length - 1;
                          }
                          setState(
                            () {},
                          );
                          var kk = GlobalObjectKey("$keystr$selectedIndex");
                          Scrollable.ensureVisible(
                            kk.currentContext!,
                            alignment: 0.5,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                          );
                        } else if (value.physicalKey == PhysicalKeyboardKey.arrowUp) {
                          selectedIndex -= 1;
                          if (selectedIndex < 0) {
                            selectedIndex = 0;
                          }
                          setState(
                            () {},
                          );
                          var kk = GlobalObjectKey("$keystr$selectedIndex");
                          Scrollable.ensureVisible(
                            kk.currentContext!,
                            alignment: 0.5,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                          );
                        } else if (value.physicalKey == PhysicalKeyboardKey.enter) {
                          Navigator.pop(contextdlg, filteredDataSource[selectedIndex]);
                        } else {
                          search();

                          setState(
                            () {},
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            child: SizedBox(
                              width: itemRect.value?.size.width ?? 0,
                              child: CustomTextbox(
                                controller: textController,
                                labelText: '',
                                hintText: '',
                                required: false,
                                autoFocus: true,
                                endPadding: 0,
                                showLabel: false,
                                padding: padd,
                                borderRadius: widget.borderRadius,
                                backgroundColor: widget.backgroundColor,
                                fontSize: widget.fontSize,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(contextdlg).brightness == Brightness.dark ? const Color.fromARGB(255, 69, 69, 69) : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 0.1,
                                    color: Colors.grey,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: ScrollablePositionedList.builder(
                                  shrinkWrap: true,
                                  itemScrollController: sc,
                                  itemCount: filteredDataSource.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return widget.topWidget == null ? Container() : widget.topWidget!(contextdlg);
                                    }
                                    var e = filteredDataSource[index - 1];
                                    return TextButton(
                                      key: GlobalObjectKey("$keystr${index - 1}"),
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          foregroundColor:
                                              ThemeHelper.isDarkMode(contextdlg) ? Color.fromARGB(255, 221, 221, 221) : Color.fromARGB(255, 39, 39, 39),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                          backgroundColor: index - 1 == selectedIndex
                                              ? Colors.red
                                              : index % 2 == 0
                                                  ? Colors.grey.withOpacity(0.1)
                                                  : null,
                                          minimumSize: const Size(0, 0)),
                                      child: widget.displayMemberBuilder != null
                                          ? widget.displayMemberBuilder!(e)
                                          : Padding(
                                              padding: EdgeInsets.only(bottom: 2),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${e[widget.displayMember]}",
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      onPressed: () {
                                        Navigator.pop(contextdlg, e);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  if (widget.isMobileView) {
                    return Dialog(
                      child: dialogContent,
                    );
                  }
                  return Stack(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: itemRect,
                          builder: (context, value, _) {
                            return Positioned(
                              width: max(400, (itemRect.value?.size.width ?? 0) + 20),
                              top: (itemRect.value?.top ?? 0) - 10,
                              left: (itemRect.value?.left ?? 0) - 10,
                              child: Container(
                                constraints: BoxConstraints(maxHeight: (itemRect.value?.height ?? 0) - ((itemRect.value?.top ?? 0))),
                                child: dialogContent,
                              ),
                            );
                          }),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        selectedItem = value;
        selectedValue = value[widget.valueMember];
        selectedText = value[widget.displayMember];
        if (widget.selectionChanged != null) {
          widget.selectionChanged!(value, selectedValue, selectedText);
        }
      } else if (widget.newTextItem && textController.text.isNotEmpty) {
        selectedItem = null;
        selectedValue = null;
        selectedText = textController.text;
        if (widget.selectionChanged != null) {
          widget.selectionChanged!(null, null, selectedText);
        }
      }
      if (tabPress) mainFn.nextFocus();
      // else {
      //   selectedItem = value;
      //   selectedValue = null;
      //   selectedText = "";
      // }
      isDialogShown = false;
      isDialogClosed = true;
      isWindowOpened = false;
      setState(() {});
    });
  }
}
