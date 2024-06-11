import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/checklistItem.dart';

class ChecklistTile extends StatelessWidget {
  final ChecklistItem item;
  final String teamId;
  final String colorHex;
  final String assignmentId;
  final String memberEmail;

  const ChecklistTile({
    super.key,
    required this.item,
    required this.teamId,
    required this.colorHex,
    required this.assignmentId,
    required this.memberEmail,
  });
  Color getColorFromHex(String hexColor) {
    final int hexCode = int.parse(hexColor.replaceFirst('#', ''), radix: 16);
    return Color(0xFF000000 | hexCode);
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);

    return ListTile(
      leading: Checkbox(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return getColorFromHex(colorHex); // 선택된 상태일 때 색상
            }
            return Colors.white; // 그 외 상태에서의 색상
          },
        ),
        value: item.isChecked,
        onChanged: (bool? value) {
          appState.updateChecklistItem(
            teamId,
            assignmentId,
            memberEmail,
            item.id,
            {'isChecked': value},
          );
        },
      ),
      title: Text(item.content),
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
                      title: const Text('Edidt'),
                      onTap: () {
                        // Edit functionality
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                      onTap: () {
                        // appState.deleteChecklistItem(
                        //   teamId,
                        //   assignmentId,
                        //   memberId,
                        //   item.id,
                        // );
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
