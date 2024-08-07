import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app1.dart';
import 'package:team_check_mate/model/team.dart';

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  static Color getColorFromHex(String hexColor) {
    final int hexCode = int.parse(hexColor.replaceFirst('#', ''), radix: 16);
    return Color(0xFF000000 | hexCode);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20.0),
          right: Radius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: getColorFromHex(team.color),
            border: Border.all(
              color: getColorFromHex(team.color),
              width: 1.5,
            ),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20.0),
              right: Radius.circular(20.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Text(
                team.title,
                style: const TextStyle(),
                maxLines: 1,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(Icons.add_circle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
