import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/model/member.dart';
import 'package:team_check_mate/widget/assignmentCard.dart';
import 'package:team_check_mate/widget/checklistTile.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage({super.key});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    var teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    var assignmentState = Provider.of<ApplicationState>(context, listen: true)
        .assignmentController;
    var memberState =
        Provider.of<ApplicationState>(context, listen: true).memberController;

    var team = teamState.selectedTeam;
    var assignment = assignmentState.selectedAssignment;

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
            "과제 정보",
            style: GoogleFonts.poppins(
              fontSize: 22,
            ),
          ),
        ),
        body: Column(
          children: [
            AssignmentCard(team: team!, assignment: assignment!),
            NameCards(teamId: team.id, teamColor: team.color),
            CheckListTile(
                teamId: team.id,
                teamColor: team.color,
                assignmentId: assignment.id),
          ],
        ));
  }
}
