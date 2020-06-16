import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/components/circle_checkbox.dart';
import 'package:music_player/models/item.dart';

class SelectionList extends StatefulWidget {
  SelectionList({
    @required this.items,
    @required this.onPressedSave,
  });

  final List<Item> items;
  final Function(List<Item> checkedList) onPressedSave;

  @override
  _SelectionListState createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  bool _selectAll = false;
  int _count = 0;

  List<Item> _getCheckedList() {
    return widget.items.where((item) => item.checked).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('$_count item${_count > 1 ? 's' : ''} selected'),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () => widget.onPressedSave(_getCheckedList()),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CircleCheckbox(
              checked: _selectAll,
              margin: EdgeInsets.only(
                right: 12.0,
              ),
              checkColor: kPlayerIconColor,
              onChecked: (v) {
                setState(() {
                  _selectAll = v;
                  for (var item in widget.items) {
                    item.checked = v;
                  }
                  if (v) {
                    _count = _getCheckedList().length;
                  } else {
                    _count = 0;
                  }
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(
                      widget.items[i].title,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    subtitle: Text('Unknown Artist | Unknown Album'),
                    trailing: CircleCheckbox(
                      checkColor: kPlayerIconColor,
                      checked: widget.items[i].checked,
                      onChecked: (v) {
                        setState(() {
                          widget.items[i].checked = v;
                          if (v) {
                            _count++;
                          } else {
                            _count--;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
