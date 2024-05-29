import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
              // color: Colors.white
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text("팀 정보"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.create,
                semanticLabel: 'update',
              ),
              onPressed: () {
                context.push("/home/teamDetail/teamEdit", extra: widget.team);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                semanticLabel: 'delete',
              ),
              onPressed: () {
                context.pop();
                appState.deleteTeam(widget.team.id);
              },
            ),
          ]),
      body: Center(
        child: Image.asset('assets/openFileColor/$color.png'),
      ),
    );
  }
}
