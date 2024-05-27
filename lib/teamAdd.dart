import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class TeamAddPage extends StatefulWidget {
  const TeamAddPage({super.key});

  @override
  State<TeamAddPage> createState() => _TeamAddPageState();
}

class _TeamAddPageState extends State<TeamAddPage> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 80,
          leading: TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              context.go('/home');
            },
          ),
          title: Text(
            '팀 생성하기',
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add_box_outlined,
                semanticLabel: 'add',
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: const Center(
            child: Text('asdfasdfasdfsfasdfs',
                style: TextStyle(color: Colors.white))));
  }
}
