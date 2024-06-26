import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class TeamEditPage extends StatefulWidget {
  final Team team;
  const TeamEditPage({super.key, required this.team});

  @override
  State<TeamEditPage> createState() => _TeamEditPageState();
}

class _TeamEditPageState extends State<TeamEditPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
      // backgroundColor: Colors.black,
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
        title: Text(
          '팀 수정하기',
          style: GoogleFonts.poppins(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              '확인',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                appState.updateTeam(widget.team, _titlecontroller.text);
                context.go('/home');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '팀 이름을 입력하세요';
              }
              return null;
            },
            controller: _titlecontroller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.team.title,
            ),
          ),
        ),
      ),
    );
  }
}
