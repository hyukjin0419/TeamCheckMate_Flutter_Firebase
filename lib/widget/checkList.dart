import 'package:flutter/material.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class ChecklistItem extends StatelessWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onOptionsTap;

  const ChecklistItem({
    super.key,
    required this.title,
    this.isChecked = false,
    required this.onChanged,
    required this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.purple,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                decoration: isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onOptionsTap,
          ),
        ],
      ),
    );
  }
}

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final List<Map<String, dynamic>> _items = [
    {'title': 'LMS 파일 제출하기', 'isChecked': false},
    {'title': '그래프 1 완성', 'isChecked': false},
  ];

  void _handleCheckboxChange(int index, bool? value) {
    setState(() {
      _items[index]['isChecked'] = value;
    });
  }

  void _handleOptionsTap(int index) {
    debugPrint('Options tapped for item $index');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ChecklistItem(
              title: _items[index]['title'],
              isChecked: _items[index]['isChecked'],
              onChanged: (value) => _handleCheckboxChange(index, value),
              onOptionsTap: () => _handleOptionsTap(index),
            );
          },
        ),
      ],
    );
  }
}
