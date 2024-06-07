import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/datePicker.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage(
      {super.key, required this.team, required this.assignment});
  final Assignment? assignment;
  final Team team;
  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
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
            widget.assignment!.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
            ),
          ),
        ),
        body: const Text("hello"));
  }
}
