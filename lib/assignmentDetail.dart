import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/checklistItem.dart';
import 'package:team_check_mate/model/member.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/assignmentCard.dart';
import 'package:team_check_mate/widget/checkList.dart';
import 'package:team_check_mate/widget/datePicker.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage(
      {super.key, required this.team, required this.assignment});
  final Assignment assignment;
  final Team team;
  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: IconButton(
            icon: const Icon(
              Icons.backspace_outlined,
              semanticLabel: 'back',
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            widget.assignment.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
            ),
          ),
        ),
        body: Column(
          children: [
            AssignmentCard(team: widget.team, assignment: widget.assignment),
            NameCards(teamId: widget.team.id, teamColor: widget.team.color),
            Expanded(
              child: StreamBuilder<List<Member>>(
                stream: appState.getMembersStream(widget.team.id),
                builder: (context, memberSnapshot) {
                  if (memberSnapshot.hasData) {
                    List<Member> members = memberSnapshot.data!;
                    return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        Member member = members[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: IntrinsicWidth(
                                    child: NameCardWithBtn(
                                      text: member.name,
                                      colorHex: widget.team.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // StreamBuilder<List<ChecklistItem>>(
                            //   stream: appState.getChecklistStream(
                            //       widget.team.id,
                            //       widget.assignment.id,
                            //       member.email),
                            //   builder: (context, checklistSnapshot) {
                            //     if (checklistSnapshot.hasData) {
                            //       List<ChecklistItem> checklist =
                            //           checklistSnapshot.data!;
                            //       return ListView.builder(
                            //         physics:
                            //             const NeverScrollableScrollPhysics(),
                            //         shrinkWrap: true,
                            //         itemCount: checklist.length,
                            //         itemBuilder: (context, checklistIndex) {
                            //           ChecklistItem item =
                            //               checklist[checklistIndex];
                            //           return ListTile(
                            //             title: Text(item.content),
                            //             leading: Checkbox(
                            //               value: item.isChecked,
                            //               onChanged: (bool? newValue) {
                            //                 appState.updateChecklistItem(
                            //                   widget.team.id,
                            //                   widget.assignment.id,
                            //                   member.email,
                            //                   item.id,
                            //                   {'isChecked': newValue},
                            //                 );
                            //               },
                            //             ),
                            //           );
                            //         },
                            //       );
                            //     } else if (checklistSnapshot.hasError) {
                            //       return Text(
                            //           'Error: ${checklistSnapshot.error}');
                            //     }
                            //     return const CircularProgressIndicator();
                            //   },
                            // ),
                          ],
                        );
                      },
                    );
                  } else if (memberSnapshot.hasError) {
                    return Text('Error: ${memberSnapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ));
  }
}
