import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:team_check_mate/model/assignment.dart';

class AssignmentController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Assignment? _selectedAssignment;
  Assignment? get selectedAssignment => _selectedAssignment;

  void selectAssignment(Assignment assignment) {
    _selectedAssignment = assignment;
    notifyListeners();
  }

  Stream<List<Assignment>> getAssignmentsStream(String teamId) {
    return _db
        .collection('teams')
        .doc(teamId)
        .collection('assignments')
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Assignment.fromFirestore(doc)).toList());
  }

  Future<void> addAssignment(
      String teamId, String title, String dateTime) async {
    try {
      var assignmentSnapshot = await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      int newOrder = 0;
      if (assignmentSnapshot.docs.isNotEmpty) {
        var lastAssignmnet = assignmentSnapshot.docs.first;
        newOrder = (lastAssignmnet.data()['data'] ?? 0) + 1;
      }

      final Map<String, dynamic> assignmentData = {
        'title': title,
        'dueDate': dateTime,
        'teamID': teamId,
        'order': newOrder,
        'timestamp': FieldValue.serverTimestamp(),
        'updateTimestamp': FieldValue.serverTimestamp(),
      };
      try {
        await _db
            .collection('teams')
            .doc(teamId)
            .collection('assignments')
            .add(assignmentData);
        debugPrint("Assignment added");
      } catch (e) {
        debugPrint("Error with addAssignment function: $e");
      }
    } catch (e) {
      debugPrint("Error when getting order from Assignment Lists\n");
    }
  }

  Future<void> deleteAssignment(String teamId, String assignmentId) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .delete();
      debugPrint("Assignment deleted");
    } catch (e) {
      debugPrint("Error deleting assignment: $e");
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
        'updateTimestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Assignment updated");
    } catch (e) {
      debugPrint("Error updating assignment: $e");
    }
  }

  Future<void> updateAssignmentOrder(
      String teamId, String assignmentId, int newOrder) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .collection('assignments')
          .doc(assignmentId)
          .update({'order': newOrder});

      debugPrint('Assignment $assignmentId order updated to $newOrder');
    } catch (e) {
      debugPrint('Error updating assignment order: $e');
    }
  }
}
