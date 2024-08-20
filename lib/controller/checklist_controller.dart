import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:team_check_mate/model/checklistItem.dart';

class ChecklistController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
}
