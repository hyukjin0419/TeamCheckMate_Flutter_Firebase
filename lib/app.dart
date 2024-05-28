import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_check_mate/firebase_options.dart';
import 'package:team_check_mate/model/team.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    // init();
  }
/*-------------------------------------변수--------------------------------------*/
  //로그인이 되었는지 안 되었는지
  bool _loggedIn = false;
  // _private변수이기 대문에 getter 필요
  bool get loggedIn => _loggedIn;
  String? uid;

  StreamSubscription<QuerySnapshot>? _teamSubscription;
  final List<Team> _teams = [];
  List<Team> get teams => _teams;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //구글 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // 사용자가 로그인을 취소하거나 완료하지 않았을 경우
        print("Google Sign-In was cancelled or not completed by the user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Missing Google Auth Token");
        return null;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // FirebaseAuth를 통해 사용자 인증
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _loggedIn = true;
      notifyListeners();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Stream<List<Team>> getTeamsStream() {
    return _db.collection('teams').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addTeam(String title) async {
    final Map<String, dynamic> teamData = {
      'title': title,
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('teams').add(teamData);
    } catch (e) {
      print("[add.part] Error with addTeam function");
    }
  }
}
