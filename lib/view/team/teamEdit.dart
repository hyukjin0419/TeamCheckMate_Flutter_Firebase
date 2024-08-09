import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/controller/team_controller.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/colorPicker.dart';

class TeamEditPage extends StatefulWidget {
  const TeamEditPage({super.key});

  @override
  State<TeamEditPage> createState() => _TeamEditPageState();
}

class _TeamEditPageState extends State<TeamEditPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String selectedColor;
  late TeamController teamState;
  late var team;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    team = teamState.selectedTeam;

    if (team != null) {
      selectedColor = team.color;
      _titlecontroller.text = team.title;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                teamState.updateTeam(
                    team!, _titlecontroller.text, selectedColor);
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
                  // hintText: team!.title,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => pickColor(context),
            child: const Text('색상 선택'),
          ),
        ],
      ),
    );
  }

  void pickColor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ColorPicker(
          onColorSelected: (String color) {
            setState(() {
              selectedColor = color;
              debugPrint(selectedColor);
            });
          },
        );
      },
    );
    debugPrint(selectedColor);
  }
}
