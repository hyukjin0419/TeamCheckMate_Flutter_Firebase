import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/checklistItem.dart';

enum ChecklistTileState { creating, editing, basic }

class ChecklistTile extends StatefulWidget {
  final ChecklistItem item;
  final String teamId;
  final String assignmentId;
  final String memberEmail;
  final String colorHex;
  final ChecklistTileState initialState;

  const ChecklistTile({
    super.key,
    required this.item,
    required this.teamId,
    required this.assignmentId,
    required this.memberEmail,
    required this.colorHex,
    this.initialState = ChecklistTileState.basic,
  });

  @override
  _ChecklistTileState createState() => _ChecklistTileState();
}

class _ChecklistTileState extends State<ChecklistTile> {
  late ChecklistTileState currentState;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
    _controller = TextEditingController(text: widget.item.content);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && currentState == ChecklistTileState.editing) {
        _submitForm();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_controller.text.isNotEmpty) {
      if (currentState == ChecklistTileState.creating) {
        Provider.of<ApplicationState>(context, listen: false).addChecklistItem(
          widget.teamId,
          widget.assignmentId,
          widget.memberEmail,
          _controller.text,
        );
      } else {
        Provider.of<ApplicationState>(context, listen: false)
            .updateChecklistItem(
          widget.teamId,
          widget.assignmentId,
          widget.memberEmail,
          widget.item.id,
          {'content': _controller.text},
        );
      }
      setState(() {
        currentState = ChecklistTileState.basic;
      });
    }
  }

  void _toggleEditing() {
    setState(() {
      currentState = ChecklistTileState.editing;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return GestureDetector(
      onTap: () {
        if (currentState == ChecklistTileState.basic) {
          _toggleEditing();
        }
      },
      child: ListTile(
        leading: Checkbox(
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return getColorFromHex(widget.colorHex);
              }
              return Colors.white;
            },
          ),
          side: BorderSide(color: getColorFromHex(widget.colorHex), width: 2.0),
          value: widget.item.isChecked,
          onChanged: (bool? value) {
            appState.updateChecklistItem(
              widget.teamId,
              widget.assignmentId,
              widget.memberEmail,
              widget.item.id,
              {'isChecked': value},
            );
          },
        ),
        title: currentState == ChecklistTileState.basic
            ? Text(widget.item.content)
            : TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onFieldSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: getColorFromHex(widget.colorHex), width: 1.0),
                  ),
                ),
              ),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {
                          Navigator.pop(context);
                          _toggleEditing();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: () {
                          appState.deleteChecklistItem(
                              widget.teamId,
                              widget.assignmentId,
                              widget.memberEmail,
                              widget.item.id);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color getColorFromHex(String hexColor) {
    final int hexCode = int.parse(hexColor.replaceFirst('#', ''), radix: 16);
    return Color(0xFF000000 | hexCode);
  }
}
