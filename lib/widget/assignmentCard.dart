import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/modalBasic.dart';

String getTimeRemaining(DateTime? dueDate) {
  if (dueDate == null) {
    return "No due date set";
  }

  Duration difference = dueDate.difference(DateTime.now());
  if (difference.isNegative) {
    return "The deadline has passed.";
  } else if (difference.inDays > 1) {
    return "${difference.inDays} days left";
  } else {
    return "${difference.inHours}h ${difference.inMinutes % 60}m left";
  }
}

class AssignmentCard extends StatefulWidget {
  final Assignment assignment;
  final Team team;

  const AssignmentCard(
      {super.key, required this.team, required this.assignment});

  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  late Timer _timer;
  late String _timeRemaining;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.assignment.dueDate.isNotEmpty
        ? DateTime.tryParse(widget.assignment.dueDate)
        : null;
    _timeRemaining = getTimeRemaining(_dueDate);
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      setState(() {
        _timeRemaining = getTimeRemaining(_dueDate);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth;
    String title = widget.assignment.title;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              context.push(
                "/home/teamDetail/assignmentDetail",
                extra: {'team': widget.team, 'assignment': widget.assignment},
              );
            },
            child: SizedBox(
              width: folderWidth,
              child: Image.asset(
                'assets/images/assginemt_container.png',
              ),
            ),
          ),
          Positioned(
            left: 25,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dueDate != null
                        ? "Duedate: ${widget.assignment.dueDate} ($_timeRemaining)"
                        : "No due date set",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: GoogleFonts.poppins(fontSize: 22),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 1,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint('Vertical dots tapped!');
                BottomModal.showCustomDialog(
                    context, widget.team.color, widget.assignment, widget.team);
              },
              child: const SizedBox(
                width: 40,
                height: 90,
              ),
            ),
          )
        ],
      ),
    );
  }
}
