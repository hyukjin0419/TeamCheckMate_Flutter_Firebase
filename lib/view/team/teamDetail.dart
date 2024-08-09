import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/controller/team_controller.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/member.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/assignmentCard.dart';
import 'package:team_check_mate/widget/modalBasic.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class TeamDetailPage extends StatefulWidget {
  const TeamDetailPage({super.key});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  @override
  Widget build(BuildContext context) {
    var teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    var assignmentState = Provider.of<ApplicationState>(context, listen: true)
        .assignmentController;
    var team = teamState.selectedTeam;

    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth;
    double folderHeight = folderWidth / 2.5;

    String color = team!.color;

    // ignore: unused_local_variable

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Colors.black,
          leadingWidth: 80,
          leading: IconButton(
            icon: const Icon(
              Icons.backspace_outlined,
              semanticLabel: 'back',
              // color: Colors.white
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            "팀 정보",
            style: GoogleFonts.poppins(
              fontSize: 22,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
                initialValue: "no choise",
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  if (value == 'delete') {
                    teamState.deleteTeam(team.id);
                    context.pop();
                  } else if (value == 'edit') {
                    context.push("/home/teamDetail/teamEdit", extra: team);
                  } else if (value == 'invite') {
                    context.push("/home/teamDetail/teamQR", extra: team);
                  } else if (value == 'create') {
                    context.push("/home/teamDetail/assignmentAdd", extra: team);
                  }
                  debugPrint(value);
                },
                itemBuilder: (BuildContext context) =>
                    // onSelected:
                    <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'create',
                        child: ListTile(
                          leading: Icon(
                            Icons.post_add,
                          ),
                          title: Text('과제 추가하기'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'invite',
                        child: ListTile(
                            leading: Icon(Icons.qr_code),
                            title: Text("팀원 초대하기")),
                      ),
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text("팀 수정하기")),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          title: Text('팀 삭제하기'),
                          textColor: Colors.red,
                        ),
                      ),
                    ]),
          ]),
      body: Column(
        children: [
          SizedBox(
            width: folderWidth,
            height: folderHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/openFileColor/$color.png',
                ),
                Positioned(
                  top: folderHeight * (6 / 10),
                  child: Text(
                    team.title,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          Flexible(child: NameCards(teamId: team.id, teamColor: team.color)),
          Flexible(
            child: StreamBuilder<List<Assignment>>(
              stream: assignmentState.getAssignmentsStream(team.id),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var assignments = snapshot.data!;
                  return ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (BuildContext context, int index) {
                      var assignment = assignments[index];
                      // return null;
                      return AssignmentCard(team: team, assignment: assignment);
                    },
                  );
                } else {
                  return const Center(child: Text("No Assigmnets founds"));
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}
