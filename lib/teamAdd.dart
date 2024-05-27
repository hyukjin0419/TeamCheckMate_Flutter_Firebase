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
          leading: IconButton(
            icon: const Icon(Icons.backspace_outlined,
                semanticLabel: 'back', color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            '팀 생성하기',
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text('확인',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
        body: const Center(
            child: Text('asdfasdfasdfsfasdfs',
                style: TextStyle(color: Colors.white))));
  }
}
