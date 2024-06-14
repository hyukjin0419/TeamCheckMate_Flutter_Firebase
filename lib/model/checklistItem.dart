import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.isChecked,
    required this.content,
    required this.timestamp,
    required this.updateTimestamp,
  });
  String id;
  bool isChecked;
  String content;
  Timestamp timestamp;
  Timestamp updateTimestamp;

  factory ChecklistItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChecklistItem(
      id: doc.id,
      isChecked: data['isChecked'] ?? false,
      content: data['content'] ?? '',
      timestamp: data['timestamp'],
      updateTimestamp: data['updateTimestamp'] ?? '',
    );
  }
}
