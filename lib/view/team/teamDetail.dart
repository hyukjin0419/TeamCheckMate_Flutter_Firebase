import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/controller/assignment_controller.dart';
import 'package:team_check_mate/controller/team_controller.dart';
import 'package:team_check_mate/model/assignment.dart';

import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/assignmentCard.dart';

import 'package:team_check_mate/widget/nameCard.dart';

class TeamDetailPage extends StatefulWidget {
  const TeamDetailPage({super.key});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  List<Assignment> _assignments = [];
  late TeamController teamState;
  late var team;
  late AssignmentController assignmentState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    assignmentState = Provider.of<ApplicationState>(context, listen: true)
        .assignmentController;
    team = teamState.selectedTeam;
  }

  @override
  Widget build(BuildContext context) {
    // var team = teamState.selectedTeam;
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
                    teamState.selectTeam.call(team);
                    context.push("/home/teamDetail/teamEdit");
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
                  _assignments = snapshot.data!;
                  // assignments.sort((a, b) => a.order.compareTo(b.order));
                  return ReorderableListView.builder(
                    itemCount: _assignments.length,
                    onReorder: _onReorder,
                    itemBuilder: (BuildContext context, int index) {
                      var assignment = _assignments[index];
                      return _buildAssignmentCard(team, assignment, index);
                      // return AssignmentCard(team: team, assignment: assignment);
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

  Widget _buildAssignmentCard(Team team, Assignment assignment, int index) {
    return ListTile(
      key: ValueKey(assignment.id),
      title: AssignmentCard(
        team: team,
        assignment: assignment,
      ),
    );
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    // UI 업데이트
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; // 새로운 인덱스가 올드 인덱스보다 클 경우 인덱스를 조정
      }
      // 드래그된 항목을 리스트에서 제거하고, 새로운 위치에 삽입
      final Assignment movedAssignment = _assignments.removeAt(oldIndex);
      _assignments.insert(newIndex, movedAssignment);
    });

    // Firebase에 업데이트
    await _updateAssignmentOrderInFirebase();
  }

  Future<void> _updateAssignmentOrderInFirebase() async {
    for (int i = 0; i < _assignments.length; i++) {
      Assignment assignment = _assignments[i];
      await assignmentState.updateAssignmentOrder(team.id, assignment.id, i);
    }
  }
}
