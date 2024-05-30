import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // backgroundColor: const Color.fromRGBO(231, 228, 192, 1.0),
      appBar: AppBar(
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
                  crossAxisCount: 2, // 한 줄에 두 개의 아이템이 표시됩니다.
                  crossAxisSpacing: 10.0, // 가로 간격
                  mainAxisSpacing: 10.0, // 세로 간격
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
    );
  }
}

// class FolderCard extends StatelessWidget {
//   final Team team;
//   const FolderCard({super.key, required this.team});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double cardWidth = screenWidth * 0.8;
//     double cardHeight = cardWidth / 3.5;

//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         // color: const Color.fromRGBO(230, 232, 133, 1.0),
//         child: SizedBox(
//           width: cardWidth,
//           height: cardHeight,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
//                 child: Text(
//                   team.title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     // color: const Color.fromRGBO(95, 98, 9, 1.0)
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 5, 10, 20),
//                 child: Text(
//                   team.id,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15,
//                     // color: const Color.fromRGBO(150, 148, 148, 1.0)),
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class FolderCard extends StatelessWidget {
  final Team team;
  const FolderCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    String color = team.color;
    String title = team.title;

    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth / 2;
    double folderHeight = folderWidth * 0.7;
    print(folderWidth);
    print(folderHeight);
    // context.push("/home/teamDetail", extra: team);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.push("/home/teamDetail", extra: team);
          },
          child: SizedBox(
            width: folderWidth,
            height: folderHeight * 0.9,
            child: Image.asset(
              'assets/fileColor/$color.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: folderHeight * 0.45,
          child: Text(
            title,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
