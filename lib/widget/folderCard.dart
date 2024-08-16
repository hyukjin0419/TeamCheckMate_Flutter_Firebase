import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/model/team.dart';

class FolderCard extends StatelessWidget {
  final Team team;
  const FolderCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    var teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    String color = team.color;
    String title = team.title;

    double screenWidth = MediaQuery.of(context).size.width;
    double folderWidth = screenWidth / 2;
    double folderHeight = folderWidth * 0.7;

    // context.push("/home/teamDetail", extra: team);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            teamState.selectTeam.call(team);
            context.push("/home/teamDetail");
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
        Positioned(
          right: 10,
          top: folderHeight * 0.7,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print('Vertical dots tapped!');
            },
            child: const SizedBox(
              width: 25,
              height: 30,
            ),
          ),
        )
      ],
    );
  }
}
