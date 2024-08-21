import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.teamId,
    required this.assignmentId,
    required this.memberEmail,
    required this.isChecked,
    required this.content,
    required this.order,
    required this.timestamp,
    required this.updateTimestamp,
  });
  String id;
  String teamId;
  String assignmentId;
  String memberEmail;
  bool isChecked;
  String content;
  int order;
  Timestamp timestamp;
  Timestamp updateTimestamp;

  factory ChecklistItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChecklistItem(
        id: doc.id,
        teamId: data['teamId'],
        assignmentId: data['assignmentId'],
        memberEmail: data['memberEmail'],
        isChecked: data['isChecked'] ?? false,
        content: data['content'] ?? '',
        timestamp: data['timestamp'],
        updateTimestamp: data['updateTimestamp'],
        order: data['order']);
  }
}
