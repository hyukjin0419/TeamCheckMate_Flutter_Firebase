// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var appState =
        Provider.of<ApplicationState>(context, listen: true).authController;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 201.0),
            child: Lottie.asset('assets/login_animation.json'),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () async {
                    await appState.signInWithGoogle();
                    if (appState.loggedIn) {
                      context.go("/home");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4286f4),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5.0,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fixedSize: const Size(200, 30),
                  ),
                  child: const Text('Sign in with Google'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go("/home");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4286f4),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5.0,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fixedSize: const Size(200, 30),
                  ),
                  child: const Text('Go to Home'),
                ),
                const Padding(padding: EdgeInsets.all(4.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
