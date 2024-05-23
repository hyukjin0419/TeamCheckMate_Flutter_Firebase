import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () async {
                await appState.signInWithGoogle();
                if (appState.loggedIn) {
                  // context.go("/");
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
            const Padding(padding: EdgeInsets.all(4.0)),
          ],
        ),
      ),
    );
  }
}
