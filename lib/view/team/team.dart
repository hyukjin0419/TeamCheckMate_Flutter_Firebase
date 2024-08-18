import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/widget/folderCard.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> _teams = [];

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _gridViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var userAppState =
        Provider.of<ApplicationState>(context, listen: true).authController;
    var teamState =
        Provider.of<ApplicationState>(context, listen: true).teamController;
    var teamOrderState = Provider.of<ApplicationState>(context, listen: true)
        .teamOrderController;
    var currentUser = userAppState.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Team',
          style: GoogleFonts.poppins(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.group,
              semanticLabel: 'join',
            ),
            onPressed: () {
              context.push("/home/teamJoin");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              semanticLabel: 'add',
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
          stream: teamState.getTeamsStream(currentUser),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.hasData) {
              _teams = snapshot.data!;
              List<Widget> generatedChildren = _teams.map((team) {
                return FolderCard(
                  key: ValueKey(team.id),
                  team: team,
                );
              }).toList();

              return ReorderableBuilder(
                scrollController: _scrollController,
                onReorder: (ReorderedListFunction reorderedListFunction) async {
                  setState(() {
                    _teams = reorderedListFunction(_teams) as List<Team>;
                  });
                  // Firebase에 순서 업데이트
                  // for (int i = 0; i < _teams.length; i++) {
                  //   debugPrint("_team[i].id: ${_teams[i].id}");
                  // }
                  await teamOrderState.updateTeamOrders(
                    currentUser!.email!,
                    _teams,
                  );
                },
                builder: (children) {
                  return GridView(
                    key: _gridViewKey,
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.2,
                    ),
                    children: children,
                  );
                },
                children: generatedChildren,
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
