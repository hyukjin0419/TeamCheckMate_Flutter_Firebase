import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.teamId,
    required this.assignmentId,
    required this.memberEmail,
    required this.isChecked,
    required this.content,
    required this.timestamp,
    required this.updateTimestamp,
  });
  String id;
  String teamId;
  String assignmentId;
  String memberEmail;
  bool isChecked;
  String content;
  Timestamp timestamp;
  Timestamp updateTimestamp;

  // Firebase에서 데이터를 읽고 쓰기 위한 메서드
  factory ChecklistItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChecklistItem(
      teamId: '',
      assignmentId: '',
      memberEmail: '',
      id: doc.id,
      isChecked: data['isChecked'] ?? false,
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? '',
      updateTimestamp: data['updateTimestamp'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'memberId': memberEmail,
      'isChecked': isChecked,
      'content': content,
    };
  }
}
