import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class AssignmentAddPage extends StatefulWidget {
  const AssignmentAddPage({super.key, required this.team});
  final Team team;
  @override
  State<AssignmentAddPage> createState() => _AssignmentAddPageState();
}

class _AssignmentAddPageState extends State<AssignmentAddPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          '팀 생성하기',
          style: GoogleFonts.poppins(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('확인',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.go('/home');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '팀 이름을 입력하세요',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
