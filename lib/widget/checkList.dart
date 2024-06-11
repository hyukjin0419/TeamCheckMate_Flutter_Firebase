import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/checklistItem.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class ChecklistTile extends StatelessWidget {
  final ChecklistItem item;
  final String teamId;
  final String assignmentId;
  final String memberEmail;

  const ChecklistTile({
    super.key,
    required this.item,
    required this.teamId,
    required this.assignmentId,
    required this.memberEmail,
  });

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);

    return ListTile(
      leading: Checkbox(
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
        icon: const Icon(Icons.more_vert),
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
