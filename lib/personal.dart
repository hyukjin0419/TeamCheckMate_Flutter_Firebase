import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';

class IndividualPage extends StatelessWidget {
  const IndividualPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Individual', style: GoogleFonts.poppins(fontSize: 22)),
      ),
      body: Center(
        child: appState.currentUser?.email != null
            ? Text(
                appState.currentUser!.email!,
                style: GoogleFonts.poppins(fontSize: 16),
              )
            : Text(
                'No user logged in',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
      ),
    );
  }
}
