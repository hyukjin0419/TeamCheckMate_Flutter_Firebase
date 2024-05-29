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
    String color = "CCEEFF";
    // ignore: unused_local_variable
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
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
        title: Text(widget.team.title),
      ),
      body: Center(
        child: Image.asset('assets/openFileColor/$color.png'),
      ),
    );
  }
}
