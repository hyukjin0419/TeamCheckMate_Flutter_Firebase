import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:team_check_mate/controller/team_order_controller.dart';
import 'package:team_check_mate/model/team.dart';

class TeamController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TeamOrderController _teamOrderController =
      TeamOrderController(); // TeamOrderController 인스턴스 생성

  final List<Team> _teams = [];
  List<Team> get teams => _teams;

  Team? _selectedTeam;
  Team? get selectedTeam => _selectedTeam;

  void selectTeam(Team team) {
    _selectedTeam = team;
    notifyListeners();
  }

  // Stream<List<Team>> getTeamsStream(User? currentUser) {
  //   return _db
  //       .collection('teams')
  //       .where('memberIds', arrayContains: currentUser!.email)
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList());
  // }

  Stream<List<Team>> getTeamsStream(User? currentUser) {
    String? userEmail = currentUser?.email;

    return _db
        .collection('users')
        .doc(userEmail)
        .collection('teamOrders')
        .orderBy('order')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Team> teams = [];
      for (var doc in snapshot.docs) {
        var teamDoc = await _db.collection('teams').doc(doc.id).get();
        if (teamDoc.exists) {
          teams.add(Team.fromFirestore(teamDoc));
        }
      }
      // debugPrint("getStream");
      // for (var team in teams) {
      //   debugPrint(team.id);
      // }

      return teams;
    });
  }

  Future<void> createTeam(String title, String color, User? currentUser) async {
    DocumentReference teamRef = await _db.collection('teams').add({
      'title': title,
      'color': color,
      'timestamp': FieldValue.serverTimestamp(),
      'updateTimestamp': FieldValue.serverTimestamp(),
    });
    String teamId = teamRef.id;
    String? userEmail = currentUser?.email;

    var userTeamOrders = await _db
        .collection('users')
        .doc(userEmail)
        .collection('teamOrders')
        .orderBy('order', descending: true)
        .limit(1)
        .get();
    int newOrder = 0;
    if (userTeamOrders.docs.isNotEmpty) {
      newOrder = userTeamOrders.docs.first['order'] + 1;
    }

    await _db
        .collection('users')
        .doc(userEmail)
        .collection('teamOrders')
        .doc(teamId)
        .set({'order': newOrder});
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

    await _teamOrderController.addTeamOrderForUser(teamId, user);

    debugPrint("Member added to team: ${user.email}");
  }

  //사용자가 팀에 가입하는 함수
  Future<void> joinTeam(String teamId, User? currentUser) async {
    if (currentUser == null) return;

    try {
      DocumentReference teamDoc = _db.collection('teams').doc(teamId);
      DocumentReference memberDoc =
          teamDoc.collection('members').doc(currentUser.email);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);
        DocumentSnapshot memberSnapshot = await transaction.get(memberDoc);

        if (teamSnapshot.exists && !memberSnapshot.exists) {
          await addTeamMember(teamId, currentUser);
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
      //1. 팀의 멤버들 가져오기
      var membersSnapshot =
          await _db.collection('teams').doc(teamId).collection('members').get();

      //2. 각 멤버의 teamOrders에서 해당 팀을 삭제
      for (var memberDoc in membersSnapshot.docs) {
        String userEmail = memberDoc.id;

        await _db
            .collection('users')
            .doc(userEmail)
            .collection('teamOrders')
            .doc(teamId)
            .delete();

        //순서 재정렬
        var remainingOrders = await _db
            .collection('users')
            .doc(userEmail)
            .collection('teamOrders')
            .orderBy('order')
            .get();

        int newOrder = 0;

        for (var doc in remainingOrders.docs) {
          await doc.reference.update({'order': newOrder});
          newOrder++;
        }
      }

      //3. 팀의 모든 하위 컬렉션 삭제
      var teamSubCollections = ['members', 'assignments'];
      for (String subCollection in teamSubCollections) {
        var subCollectionSnapShot = await _db
            .collection('teams')
            .doc(teamId)
            .collection(subCollection)
            .get();

        for (var doc in subCollectionSnapShot.docs) {
          await doc.reference.delete();
        }
      }

      //4. 팀 문서 삭제
      await _db.collection('teams').doc(teamId).delete();
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

  // Future<void> updateTeamOrder(List<Team> teams) async {
  //   WriteBatch batch = _db.batch();

  //   for (int i = 0; i < teams.length; i++) {
  //     Team team = teams[i];
  //     DocumentReference teamRef = _db.collection('teams').doc(team.id);

  //     batch.update(teamRef, {'order': i});
  //   }

  //   try {
  //     await batch.commit();
  //     debugPrint("Team order updated successfully");
  //   } catch (e) {
  //     debugPrint("Error updating team order: $e");
  //   }
  // }

  // Future<void> _addTeamOrderForUser(String teamId, User user) async {
  //   String userEmail = user.email!;

  //   //사용자 별 팀 순서에서 가장 큰 order 가져오기
  //   var userTeamOrders = await _db
  //       .collection('users')
  //       .doc(userEmail)
  //       .collection('teamOrders')
  //       .orderBy('order', descending: true)
  //       .limit(1)
  //       .get();

  //   int newOrder = 0;
  //   if (userTeamOrders.docs.isNotEmpty) {
  //     newOrder = (userTeamOrders.docs.first['order'] as int?) ?? 0 + 1;
  //   }

  //   //새로운 팀을 사용자의 팀 순서에 추가
  //   await _db
  //       .collection('users')
  //       .doc(userEmail)
  //       .collection('teamOrders')
  //       .doc(teamId)
  //       .set({'order': newOrder});

  //   debugPrint("Team order added for user: ${user.email}");
  // }
}
