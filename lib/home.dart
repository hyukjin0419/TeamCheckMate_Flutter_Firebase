import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Team>>(
        stream: appState.getTeamsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FolderCard(team: snapshot.data![index]);
              },
            );
          } else {
            return const Center(child: Text("No teams found"));
          }
        },
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final Team team;
  const FolderCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8;
    double cardHeight = cardWidth / 3.5;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(245, 245, 245, 1.0),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                child: Text(
                  team.title,
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 20),
                child: Text(
                  "부가설명부가설명부가설명부가설명부가설명부가설명",
                  style: GoogleFonts.lato(fontSize: 15),
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
