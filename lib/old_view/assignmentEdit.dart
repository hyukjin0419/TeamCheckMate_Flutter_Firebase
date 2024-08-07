// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:team_check_mate/services/app.dart';
// import 'package:team_check_mate/model/assignment.dart';
// import 'package:team_check_mate/model/team.dart';
// import 'package:intl/intl.dart';
// import 'package:team_check_mate/widget/datePicker.dart';

// class AssignmentEditPage extends StatefulWidget {
//   const AssignmentEditPage(
//       {super.key, required this.team, required this.assignment});
//   final Team team;
//   final Assignment assignment;

//   @override
//   State<AssignmentEditPage> createState() => _AssignmentEditPageState();
// }

// class _AssignmentEditPageState extends State<AssignmentEditPage> {
//   final _titlecontroller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;

//   void _handleDateTimeChanged(DateTime date, TimeOfDay time) {
//     setState(() {
//       _selectedDate = date;
//       _selectedTime = time;
//     });
//   }

//   String _formatDateTime(DateTime date, TimeOfDay time) {
//     final DateTime dateTime =
//         DateTime(date.year, date.month, date.day, time.hour, time.minute);

//     return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appState = Provider.of<ApplicationState>(context, listen: true);
//     return Scaffold(
//       // backgroundColor: Colors.black,
//       appBar: AppBar(
//         // backgroundColor: Colors.black,
//         leadingWidth: 80,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.backspace_outlined,
//             semanticLabel: 'back',
//             // color: Colors.white
//           ),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//         title: Text(
//           '과제 수정하기',
//           style: GoogleFonts.poppins(
//             fontSize: 22,
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text(
//               '확인',
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//             onPressed: () {
//               debugPrint("_selectedDate $_selectedDate");
//               if (_formKey.currentState?.validate() ?? false) {
//                 String dateTimeString = '';
//                 if (_selectedDate != null && _selectedTime != null) {
//                   dateTimeString =
//                       _formatDateTime(_selectedDate!, _selectedTime!);
//                 }
//                 appState.updateAssignment(widget.team.id, widget.assignment.id,
//                     _titlecontroller.text, dateTimeString);
//                 context.pop();
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               key: _formKey,
//               child: TextFormField(
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '과제 이름을 입력하세요';
//                   }
//                   return null;
//                 },
//                 controller: _titlecontroller,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: widget.assignment.title,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           DateTimePicker(onDateTimeChanged: _handleDateTimeChanged),
//         ],
//       ),
//     );
//   }
// }
