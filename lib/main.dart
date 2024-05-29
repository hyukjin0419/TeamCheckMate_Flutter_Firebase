import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_check_mate/app.dart';
import "package:provider/provider.dart";
import 'package:team_check_mate/home.dart';
import 'package:team_check_mate/login.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/teamAdd.dart';
import 'package:team_check_mate/teamDetail.dart';
import 'package:team_check_mate/teamEdit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'teamAdd',
            builder: ((context, state) => const TeamAddPage()),
          ),
          GoRoute(
              path: 'teamDetail',
              builder: ((context, state) {
                final team = state.extra as Team?;
                if (team != null) {
                  return TeamDetailPage(team: team);
                } else {
                  debugPrint("No team data provided");
                  return ErrorWidget(ErrorWidget);
                }
              }),
              routes: [
                GoRoute(
                    path: 'teamEdit',
                    builder: ((context, state) {
                      final team = state.extra as Team?;
                      if (team != null) {
                        return TeamEditPage(team: team);
                      } else {
                        debugPrint("No team data provided");
                        return ErrorWidget(ErrorWidget);
                      }
                    }))
              ]),
        ]),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Team Check Mate',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.teal,
            ),
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
