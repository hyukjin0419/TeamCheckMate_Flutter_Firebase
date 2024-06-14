import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_check_mate/widget/bottomNavigation.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/profile.jpg'), // Replace with actual profile image URL
            ),
            const SizedBox(height: 16),
            Text(
              'User Name',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'user@example.com',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              child: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
    );
  }
}
