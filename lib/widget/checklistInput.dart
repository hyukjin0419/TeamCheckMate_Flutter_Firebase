import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';

class CheckListInput extends StatefulWidget {
  final String teamId;
  final String assignmentId;
  final String memberEmail;
  final String colorHex;
  final Function onSubmitted;

  const CheckListInput({
    super.key,
    required this.teamId,
    required this.assignmentId,
    required this.memberEmail,
    required this.colorHex,
    required this.onSubmitted,
  });

  @override
  _CheckListInputState createState() => _CheckListInputState();
}

class _CheckListInputState extends State<CheckListInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode; // FocusNode 추가

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // 위젯이 빌드된 후 포커스 요청
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    var appState = Provider.of<ApplicationState>(context, listen: false);
    if (_controller.text.isNotEmpty) {
      appState.addChecklistItem(
        widget.teamId,
        widget.assignmentId,
        widget.memberEmail,
        _controller.text,
      );
      _controller.clear();
      widget.onSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        value: false,
        onChanged: (bool? value) {},
      ),
      title: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onFieldSubmitted: (_) => _submitForm(),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: getColorFromHex(widget.colorHex), width: 1.0),
          ),
        ),
      ),
      trailing: const Icon(Icons.more_horiz),
    );
  }

  Color getColorFromHex(String hexColor) {
    final int hexCode = int.parse(hexColor.replaceFirst('#', ''), radix: 16);
    return Color(0xFF000000 | hexCode);
  }
}
