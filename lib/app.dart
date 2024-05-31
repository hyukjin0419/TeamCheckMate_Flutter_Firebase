import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_check_mate/model/assignment.dart';

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

  // ignore: unused_field
  StreamSubscription<QuerySnapshot>? _teamSubscription;
  final List<Team> _teams = [];
  List<Team> get teams => _teams;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Team? _selectedTeam;
  Team? get selectedTeam => _selectedTeam;
  void selectTeam(Team team) {
    _selectedTeam = team;

    // notifyListeners();
  }
//
//
//
//
//

// ------------------------------------------------------------------------------------
  //구글 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // 사용자가 로그인을 취소하거나 완료하지 않았을 경우
        debugPrint(
            "Google Sign-In was cancelled or not completed by the user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint("Missing Google Auth Token");
        return null;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // FirebaseAuth를 통해 사용자 인증
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _loggedIn = true;
      notifyListeners();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Stream<List<Team>> getTeamsStream() {
    return _db.collection('teams').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addTeam(String title, String color) async {
    final Map<String, dynamic> teamData = {
      'title': title,
      'color': color,
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    };
    // print("whate");
    try {
      await _db.collection('teams').add(teamData);
      debugPrint("[add.part] Team added");
    } catch (e) {
      debugPrint("[add.part] Error with addTeam function");
      debugPrint(e as String?);
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      await _db.collection('teams').doc(teamId).delete();
      debugPrint("Team successfully deleted.");
    } catch (e) {
      debugPrint("Error deleting product: $e");
    }
  }

  Future<void> updateTeam(Team team, String newTitle) async {
    final Map<String, dynamic> teamData = {
      'title': newTitle,
      'color': team.color,
      'updateTimestamp': FieldValue.serverTimestamp(),
    };
    try {
      await _db.collection('teams').doc(team.id).update(teamData);
      debugPrint("Team $team.id successfully updated.");
    } catch (e) {
      debugPrint("Error updating product: $e");
    }
  }

  Stream<List<Assignment>> getAssignmentsStream(String teamId) {
    return _db
        .collection('teams')
        .doc(teamId)
        .collection('assignments')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Assignment.fromFirestore(doc)).toList());
  }

  Future<void> addAssignment(Team team, String title) async {
    final Map<String, dynamic> assignmentData = {
      'title': title,
      'teamID': team.id,
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    };
    // print("whate");
    try {
      await _db
          .collection('teams')
          .doc(team.id)
          .collection('assignments')
          .add(assignmentData);
      debugPrint("[add.part] Assignment added");
    } catch (e) {
      debugPrint("[add.part] Error with Assignment function");
      debugPrint(e as String?);
    }
  }
}
