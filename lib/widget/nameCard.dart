import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/member.dart';

class NameCards extends StatelessWidget {
  final String teamId;
  final String teamColor;

  const NameCards({super.key, required this.teamId, required this.teamColor});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<List<Member>>(
        stream: appState.getMembersStream(teamId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Member> members = snapshot.data ?? [];
            return SizedBox(
              height: 45,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: NameCard(
                      colorHex: teamColor,
                      text: '팀메이트',
                      isHead: true,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            child: NameCard(
                              colorHex: teamColor,
                              text: members[index].name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No members found"));
          }
        },
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  final String text;
  final String colorHex;
  final bool isHead;

  const NameCard({
    super.key,
    required this.text,
    required this.colorHex,
    this.isHead = false,
  });

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
          color: isHead ? getColorFromHex(colorHex) : Colors.white,
          border: isHead
              ? null
              : Border.all(
                  color: getColorFromHex(colorHex),
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
            text,
            style: const TextStyle(),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class NameCardWithBtn extends StatelessWidget {
  final String text;
  final String colorHex;
  final bool isHead;

  const NameCardWithBtn({
    super.key,
    required this.text,
    required this.colorHex,
    this.isHead = false,
  });

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
          color: isHead ? getColorFromHex(colorHex) : Colors.white,
          border: isHead
              ? null
              : Border.all(
                  color: getColorFromHex(colorHex),
                  width: 1.5,
                ),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(20.0),
            right: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Center(
          child: Row(
            children: [
              Text(
                text,
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
