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
import 'package:team_check_mate/widget/%08checklistTile.dart';
import 'package:team_check_mate/widget/assignmentCard.dart';
import 'package:team_check_mate/widget/checklistInput.dart';
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
  String? _activeMemberId; // 활성화된 멤버 ID를 저장

  void _toggleTextFormField(String memberId) {
    setState(() {
      if (_activeMemberId == memberId) {
        _activeMemberId = null; // 동일한 멤버를 클릭하면 비활성화
      } else {
        _activeMemberId = memberId; // 다른 멤버를 클릭하면 해당 멤버 활성화
      }
    });
  }

  void _hideTextFormField() {
    setState(() {
      _activeMemberId = null; // 입력 완료 후 비활성화
    });
  }

  List<ChecklistItem> _sortChecklistItems(List<ChecklistItem> items) {
    items.sort((a, b) {
      if (a.isChecked != b.isChecked) {
        return a.isChecked ? 1 : -1;
      }
      return a.timestamp.compareTo(b.timestamp);
    });
    return items;
  }

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
              //이름 - 체크리스트
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _toggleTextFormField(member.id);
                                    },
                                    child: IntrinsicWidth(
                                      child: NameCardWithBtn(
                                        text: member.name,
                                        colorHex: widget.team.color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_activeMemberId == member.id)
                              CheckListInput(
                                teamId: widget.team.id,
                                assignmentId: widget.assignment.id,
                                memberEmail: member.id,
                                colorHex: widget.team.color,
                                onSubmitted: _hideTextFormField,
                              ),
                            StreamBuilder<List<ChecklistItem>>(
                              stream: appState.getChecklistStream(
                                  widget.team.id,
                                  widget.assignment.id,
                                  member.id),
                              builder: (context, checklistSnapshot) {
                                if (checklistSnapshot.hasData) {
                                  List<ChecklistItem> checklist =
                                      checklistSnapshot.data!;
                                  checklist = _sortChecklistItems(checklist);
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: checklist.length,
                                    itemBuilder: (context, checklistIndex) {
                                      ChecklistItem item =
                                          checklist[checklistIndex];

                                      return ChecklistTile(
                                        item: item,
                                        teamId: widget.team.id,
                                        assignmentId: widget.assignment.id,
                                        memberEmail: member.id,
                                        colorHex: widget.team.color,
                                      );
                                    },
                                  );
                                } else if (checklistSnapshot.hasError) {
                                  return Text(
                                      'Error: ${checklistSnapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
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
