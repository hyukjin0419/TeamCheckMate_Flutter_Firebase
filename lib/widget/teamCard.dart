import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
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
    return ClipRRect(
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
        child: Center(
          child: Text(
            team.title,
            style: const TextStyle(),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
