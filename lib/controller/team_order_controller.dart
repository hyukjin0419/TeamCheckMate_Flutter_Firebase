import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_check_mate/model/teamOder.dart';

class TeamOrderController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 특정 사용자의 팀 순서 데이터를 가져오는 메서드
  Stream<List<TeamOrder>> getTeamOrders(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('teamOrders')
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TeamOrder.fromFirestore(doc)).toList());
  }

  // 특정 사용자의 팀 순서를 업데이트하는 메서드
  Future<void> updateTeamOrder(String userId, String teamId, int order) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('teamOrders')
          .doc(teamId)
          .set({'order': order}, SetOptions(merge: true));

      debugPrint('Team $teamId order for user $userId updated to $order');
    } catch (e) {
      debugPrint('Error updating team order: $e');
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
