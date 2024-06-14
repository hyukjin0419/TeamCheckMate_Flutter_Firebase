import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/checklistItem.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/checklistTile.dart';
import 'package:team_check_mate/widget/teamCard.dart';

class IndividualPage extends StatelessWidget {
  const IndividualPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    var userEmail = appState.currentUser?.email;

    return Scaffold(
      appBar: AppBar(),
      body: userEmail == null
          ? Center(
              child: Text(
                'No user logged in',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                  child: Text(
                    "$userEmail \n환영합니다.",
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: StreamBuilder<List<Team>>(
                    stream: appState.getTeamsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No teams found'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Team team = snapshot.data![index];

                            return Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: IntrinsicWidth(
                                        child: TeamCard(team: team))),
                                StreamBuilder<List<ChecklistItem>>(
                                  stream: appState.getIndividualChecklistStream(
                                      team.id, userEmail),
                                  builder: (context, checklistSnapshot) {
                                    if (checklistSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                          height: 30,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    } else if (checklistSnapshot.hasError) {
                                      return Text(
                                          'Error: ${checklistSnapshot.error}');
                                    } else if (!checklistSnapshot.hasData ||
                                        checklistSnapshot.data!.isEmpty) {
                                      return const SizedBox(
                                          height: 30,
                                          child: Center(
                                              child: Text(
                                                  'No checklist items found')));
                                    } else {
                                      return ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            checklistSnapshot.data!.length,
                                        itemBuilder: (context, checklistIndex) {
                                          ChecklistItem item = checklistSnapshot
                                              .data![checklistIndex];
                                          return ChecklistTile(
                                            item: item,
                                            teamId: team.id,
                                            assignmentId: item.assignmentId,
                                            memberEmail: item.memberEmail,
                                            colorHex: team.color,
                                          );
                                        },
                                      );
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
