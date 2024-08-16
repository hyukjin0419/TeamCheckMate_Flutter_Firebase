import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:team_check_mate/model/team.dart';

class TeamController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<Team> _teams = [];
  List<Team> get teams => _teams;

  Team? _selectedTeam;
  Team? get selectedTeam => _selectedTeam;

  void selectTeam(Team team) {
    _selectedTeam = team;
    notifyListeners();
  }

  Stream<List<Team>> getTeamsStream(User? currentUser) {
    return _db
        .collection('teams')
        .where('memberIds', arrayContains: currentUser!.email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList());
  }

  Future<void> addTeam(String title, String color, User? currentUser) async {
    DocumentReference teamRef = await _db.collection('teams').add({
      'title': title,
      'color': color,
      'leaderId': currentUser!.email,
      'memberIds': [currentUser.email],
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    });
    await addTeamMember(teamRef.id, currentUser);
  }

  Future<void> addTeamMember(String teamId, User? user) async {
    DocumentReference memberRef = _db
        .collection('teams')
        .doc(teamId)
        .collection('members')
        .doc(user!.email);

    await memberRef.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    debugPrint("Member added to team: ${user.email}");
  }

  Future<void> joinTeam(String teamId, User? currentUser) async {
    if (currentUser == null) return;

    try {
      DocumentReference teamDoc = _db.collection('teams').doc(teamId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);

        if (teamSnapshot.exists) {
          List<dynamic> memberIds = teamSnapshot['memberIds'];

          if (!memberIds.contains(currentUser.email)) {
            memberIds.add(currentUser.email);
            transaction.update(teamDoc, {'memberIds': memberIds});
            await addTeamMember(teamId, currentUser);
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
      debugPrint("Error deleting team: $e");
    }
  }

  Future<void> updateTeam(
      Team team, String newTitle, String selectedColor) async {
    final Map<String, dynamic> teamData = {
      'title': newTitle,
      'color': selectedColor,
      'updateTimestamp': FieldValue.serverTimestamp(),
    };
    try {
      await _db.collection('teams').doc(team.id).update(teamData);
      debugPrint("Team ${team.id} successfully updated.");
    } catch (e) {
      debugPrint("Error updating team: $e");
    }
  }
}
