import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;
  const TeamDetailPage({super.key, required this.team});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth * 1;
    double folderHeight = folderWidth / 2.5;

    String color = widget.team.color;
    // ignore: unused_local_variable
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Colors.black,
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
          title: const Text("팀 정보"),
          actions: <Widget>[
            PopupMenuButton<String>(
                initialValue: "no choise",
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  if (value == 'delete') {
                    appState.deleteTeam(widget.team.id);
                    context.pop();
                  } else if (value == 'edit') {
                    context.push("/home/teamDetail/teamEdit",
                        extra: widget.team);
                  } else if (value == 'invite') {
                    context.push("/home/teamDetail/teamQR", extra: widget.team);
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
            // IconButton(
            //   icon: const Icon(
            //     Icons.create,
            //     semanticLabel: 'update',
            //   ),
            //   onPressed: () {
            //     context.push("/home/teamDetail/teamEdit", extra: widget.team);
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.delete,
            //     semanticLabel: 'delete',
            //   ),
            //   onPressed: () {
            //     context.pop();
            //     appState.deleteTeam(widget.team.id);
            //   },
            // ),
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
                    widget.team.title,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),

          // QrImageView(
          //   data: widget.team.id,
          //   version: QrVersions.auto,
          //   size: 200.0,
          // ),
        ],
      ),
    );
  }
}
