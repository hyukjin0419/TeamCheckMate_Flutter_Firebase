import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/bottomNavigation.dart';
import 'package:team_check_mate/widget/folderCard.dart';

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
      // backgroundColor: const Color.fromRGBO(231, 228, 192, 1.0),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: const Color.fromRGBO(231, 228, 192, 1.0),
        title: Text(
          'Team',
          style: GoogleFonts.poppins(
            fontSize: 22,
            // color: const Color.fromRGBO(95, 98, 9, 1.0)
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.group,
              semanticLabel: 'join',
              // color: Color.fromRGBO(95, 98, 9, 1.0),
            ),
            onPressed: () {
              context.push("/home/teamJoin");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              semanticLabel: 'add',
              // color: Color.fromRGBO(95, 98, 9, 1.0),
            ),
            onPressed: () {
              context.push("/home/teamAdd");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
        child: StreamBuilder<List<Team>>(
          stream: appState.getTeamsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.2,
                ),
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
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(index: 1),
    );
  }
}
