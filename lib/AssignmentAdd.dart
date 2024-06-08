import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/datePicker.dart';
import 'package:intl/intl.dart';

class AssignmentAddPage extends StatefulWidget {
  const AssignmentAddPage({super.key, required this.team});
  final Team team;
  @override
  State<AssignmentAddPage> createState() => _AssignmentAddPageState();
}

class _AssignmentAddPageState extends State<AssignmentAddPage> {
  final _titlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _handleDateTimeChanged(DateTime date, TimeOfDay time) {
    setState(() {
      _selectedDate = date;
      _selectedTime = time;
    });
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

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
          '과제 생성하기',
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
                String dateTimeString = '';
                debugPrint("_selectedDate $_selectedDate");
                if (_selectedDate != null && _selectedTime != null) {
                  dateTimeString =
                      _formatDateTime(_selectedDate!, _selectedTime!);
                }
                debugPrint(dateTimeString);
                appState.addAssignment(
                  widget.team,
                  _titlecontroller.text,
                  dateTimeString,
                );
                context.pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '과제 이름을 입력하세요';
                    }
                    return null;
                  },
                  controller: _titlecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '과제 이름을 입력하세요',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DateTimePicker(onDateTimeChanged: _handleDateTimeChanged),
          ],
        ),
      ),
    );
  }
}
