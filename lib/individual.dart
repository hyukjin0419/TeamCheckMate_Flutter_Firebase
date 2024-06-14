import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/checklistItem.dart';

class IndividualPage extends StatelessWidget {
  const IndividualPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    var userEmail = appState.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 22)),
      ),
      body: userEmail == null
          ? Center(
              child: Text(
                'No user logged in',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : Column(
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
                  child: StreamBuilder<List<ChecklistItem>>(
                    stream: appState.getUserChecklistItems(userEmail),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No checklist items found'));
                      } else {
                        List<ChecklistItem> checklistItems = snapshot.data!;
                        return ListView.builder(
                          itemCount: checklistItems.length,
                          itemBuilder: (context, index) {
                            ChecklistItem item = checklistItems[index];
                            return ListTile(
                              title: Text(item.content),
                              trailing: Checkbox(
                                value: item.isChecked,
                                onChanged: (bool? value) {
                                  // Handle checkbox change
                                },
                              ),
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
