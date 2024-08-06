import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_check_mate/model/assignment.dart';
import 'package:team_check_mate/model/checklistItem.dart';
import 'package:team_check_mate/model/member.dart';
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
  // String? uid;
  User? currentUser;

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
      currentUser = userCredential.user;

      _loggedIn = true;
      notifyListeners();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

//-----------------------------Team & Member------------------------------------
  Stream<List<Team>> getTeamsStream() {
    return _db
        .collection('teams')
        .where('memberIds', arrayContains: currentUser!.email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList());
  }

  Future<void> addTeam(String title, String color) async {
    DocumentReference teamRef = await _db.collection('teams').add({
      'title': title,
      'color': color,
      'leaderId': currentUser!.email,
      'memberIds': [currentUser!.email],
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    });
    try {
      await addTeamMember(teamRef.id, currentUser!);

      debugPrint("[add.part] Team added");
    } catch (e) {
      debugPrint("[add.part] Error with addTeam function");
      debugPrint(e as String?);
    }
  }

  Future<void> addTeamMember(String teamId, User user) async {
    DocumentReference memberRef = _db
        .collection('teams')
        .doc(teamId)
        .collection('members')
        .doc(user.email);

    await memberRef.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    debugPrint("Member added to team: ${user.email}");
  }

  Stream<List<Member>> getMembersStream(String teamId) {
    return _db
        .collection('teams')
        .doc(teamId)
        .collection('members')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Member.fromFirestore(doc)).toList());
  }

  Future<void> joinTeam(String teamId) async {
    if (currentUser == null) return;

    try {
      DocumentReference teamDoc = _db.collection('teams').doc(teamId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);

        if (teamSnapshot.exists) {
          List<dynamic> memberIds = teamSnapshot['memberIds'];

          if (!memberIds.contains(currentUser!.email)) {
            memberIds.add(currentUser!.email);

            transaction.update(teamDoc, {'memberIds': memberIds});

            // 여기서 하위 컬렉션 members에 멤버 정보 추가
            await addTeamMember(teamId, currentUser!);
          }
        }
      });

      debugPrint("User successfully joined the team.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error joining the team: $e");
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

// ------------------------Assignment---------------------------------
  Stream<List<Assignment>> getAssignmentsStream(String teamId) {
    return _db
        .collection('teams')
        .doc(teamId)
        .collection('assignments')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Assignment.fromFirestore(doc)).toList());
  }

  Future<void> addAssignment(Team team, String title, String dateTime) async {
    final Map<String, dynamic> assignmentData = {
      'title': title,
      'dueDate': dateTime,
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

  Future<void> deleteAssignment(String? teamId, String? assignmentId) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .delete();
      debugPrint("[delete.part] Assignment deleted");
    } catch (e) {
      debugPrint("[delete.part] Error deleting assignment: $e");
    }
  }

  Future<void> updateAssignment(String teamId, String assignmentId,
      String newTitle, String newDueDate) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .update({
        'title': newTitle,
        'dueDate': newDueDate,
        'updateTimestamp': FieldValue.serverTimestamp(), // 업데이트 시각 기록
      });
      debugPrint("[update.part] Assignment updated");
    } catch (e) {
      debugPrint("[update.part] Error updating assignment: $e");
    }
  }

  //-------------------------------Checklist----------------------------------------
  Stream<List<ChecklistItem>> getChecklistStream(
      String teamId, String assignmentId, String memberEmail) {
    return _db
        .collection('teams')
        .doc(teamId)
        .collection('assignments')
        .doc(assignmentId)
        .collection('members')
        .doc(memberEmail)
        .collection('checklist')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChecklistItem.fromFirestore(doc))
            .toList());
  }

  Future<void> updateChecklistItem(String teamId, String assignmentId,
      String memberEmail, String itemId, Map<String, dynamic> data) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .collection('members')
          .doc(memberEmail)
          .collection('checklist')
          .doc(itemId)
          .update(data);
    } catch (e) {
      debugPrint("Error updating checklist item: $e");
    }
  }

  Future<void> deleteChecklistItem(String teamId, String assignmentId,
      String memberEmail, String itemId) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .collection('members')
          .doc(memberEmail)
          .collection('checklist')
          .doc(itemId)
          .delete();
    } catch (e) {
      debugPrint("Error deleting checklist item: $e");
    }
  }

  Future<void> addChecklistItem(String teamId, String assignmentId,
      String memberEmail, String content) async {
    final Map<String, dynamic> checklistData = {
      'teamId': teamId,
      'assignmentId': assignmentId,
      'memberEmail': memberEmail,
      'content': content,
      'isChecked': false,
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .collection('members')
          .doc(memberEmail)
          .collection('checklist')
          .add(checklistData);
      debugPrint("[add.part] Checklist item added");
    } catch (e) {
      debugPrint("[add.part] Error with addChecklistItem function");
    }
  }

  // --------------------------Individual Page----------
  Stream<List<ChecklistItem>> getIndividualChecklistStream(
      String teamId, String userEmail) async* {
    List<ChecklistItem> allItems = [];

    var assignmentsSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('assignments')
        .get();
    for (var assignmentDoc in assignmentsSnapshot.docs) {
      var checklistSnapshot = FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentDoc.id)
          .collection('members')
          .doc(userEmail)
          .collection('checklist')
          .snapshots();

      await for (var snapshot in checklistSnapshot) {
        allItems.clear();
        for (var doc in snapshot.docs) {
          allItems.add(ChecklistItem.fromFirestore(doc));
        }
        yield allItems;
      }
    }
  }
}
