import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/widget/colorPicker.dart';

class TeamAddPage extends StatefulWidget {
  const TeamAddPage({super.key});

  @override
  State<TeamAddPage> createState() => _TeamAddPageState();
}

class _TeamAddPageState extends State<TeamAddPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedColor = 'BAF6EF';

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
  }

  @override
  Widget build(BuildContext context) {
    var teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    var userState =
        Provider.of<ApplicationState>(context, listen: true).authController;

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
                teamState.createTeam(_titlecontroller.text, selectedColor,
                    userState.currentUser);
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
          ElevatedButton(
            onPressed: () => pickColor(context),
            child: const Text('색상 선택'),
          ),
        ],
      ),
    );
  }
}
