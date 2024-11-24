import 'package:denomination/resources/color.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final Widget? titleWidget;
  final String title;
  final List<String> items;
  final ValueChanged<String> itemCallBack;
  final String currentItem;
  final String hintText;
  final bool disable;
  final EdgeInsets? padding;
  final double borderRdius;
  final double titleFontSize;
  final double itemFontSize;
  final double hintFontSize;

  const DropdownWidget({
    Key? key,
    this.titleWidget,
    this.title = "",
    required this.items,
    required this.itemCallBack,
    required this.currentItem,
    required this.hintText,
    this.disable = false,
    this.padding,
    this.borderRdius = 12.0,
    this.titleFontSize = 12.0,
    this.itemFontSize = 15.0,
    this.hintFontSize = 14.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropdownState(currentItem);
}

class _DropdownState extends State<DropdownWidget> {
  List<DropdownMenuItem<String>> dropDownItems = [];
  String currentItem;

  _DropdownState(this.currentItem);

  @override
  void initState() {
    super.initState();
    for (String item in widget.items) {
      dropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: widget.itemFontSize, color: white),
        ),
      ));
    }
  }

  @override
  void didUpdateWidget(DropdownWidget oldWidget) {
    if (currentItem != widget.currentItem) {
      setState(() {
        currentItem = widget.currentItem;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: widget.padding ??
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRdius),
                  color: fillColor,
                  border: Border.all(
                    color: lightBlue,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: IgnorePointer(
                    ignoring: widget.disable,
                    child: DropdownButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      value: currentItem,
                      isDense: true,
                      isExpanded: true,
                      items: dropDownItems,
                      borderRadius: BorderRadius.circular(widget.borderRdius),
                      dropdownColor: fillColor,
                      onChanged: (selectedItem) {
                        setState(() {
                          currentItem = selectedItem.toString();
                          widget.itemCallBack(currentItem);
                        });
                      },
                      hint: GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              widget.hintText,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: widget.hintFontSize,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
