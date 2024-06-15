import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/modalBasic.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final Team team;
  const AssignmentCard(
      {super.key, required this.team, required this.assignment});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth;
    // double folderHeight = folderWidth * 0.2;
    String title = assignment.title;
    String dueDate = assignment.dueDate; // dueDate 필드 추가

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              context.push(
                "/home/teamDetail/assignmentDetail",
                extra: {'team': team, 'assignment': assignment},
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
                    "Duedate: $dueDate",
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
            // top: 25,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint('Vertical dots tapped!');
                BottomModal.showCustomDialog(
                    context, team.color, assignment, team);
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
