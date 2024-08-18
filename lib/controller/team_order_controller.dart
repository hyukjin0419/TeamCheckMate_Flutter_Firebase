import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_check_mate/model/team.dart';
import 'package:team_check_mate/model/teamOder.dart';

class TeamOrderController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // // 특정 사용자의 팀 순서 데이터를 가져오는 메서드
  // Stream<List<TeamOrder>> getTeamOrders(String userId) {
  //   return _db
  //       .collection('users')
  //       .doc(userId)
  //       .collection('teamOrders')
  //       .orderBy('order')
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => TeamOrder.fromFirestore(doc)).toList());
  // }

  // 특정 사용자의 팀 순서를 업데이트하는 메서드
  Future<void> updateTeamOrders(String userId, List<Team> teams) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (int i = 0; i < teams.length; i++) {
        DocumentReference teamOrderRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('teamOrders')
            .doc(teams[i].id);

        batch.set(teamOrderRef, {'order': i}, SetOptions(merge: true));
        notifyListeners();
      }

      // 배치 커밋
      await batch.commit();
      debugPrint('All team orders for user $userId updated successfully');
    } catch (e) {
      debugPrint('Error updating team orders: $e');
    }
  }

  Future<void> addTeamOrderForUser(String teamId, User user) async {
    String userEmail = user.email!;

    //사용자 별 팀 순서에서 가장 큰 order 가져오기
    var userTeamOrders = await _db
        .collection('users')
        .doc(userEmail)
        .collection('teamOrders')
        .orderBy('order', descending: true)
        .limit(1)
        .get();

    int newOrder = 0;
    if (userTeamOrders.docs.isNotEmpty) {
      newOrder = (userTeamOrders.docs.first['order'] as int?) ?? 0 + 1;
    }

    //새로운 팀을 사용자의 팀 순서에 추가
    await _db
        .collection('users')
        .doc(userEmail)
        .collection('teamOrders')
        .doc(teamId)
        .set({'order': newOrder});

    debugPrint("Team order added for user: ${user.email}");
  }
}
