import 'package:flutter/material.dart';
import 'package:team_check_mate/model/team.dart';

class NameCard extends StatelessWidget {
  final String name;
  final String color;

  const NameCard({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    double width = 200;

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(30.0), right: Radius.circular(30.0)),
      child: Container(
        color: Colors.white,
        child: Text(name),
      ),
    );
  }
}
