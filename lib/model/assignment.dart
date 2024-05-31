import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  Assignment({
    required this.teamId,
    required this.id,
    // required this.creatorUid,
    required this.title,
    // required this.description,
    required this.timestamp,
    required this.updateTimestamp,
  });
  final String teamId;
  final String id;
  // final String creatorUid;
  final String title;

  // final String description;
  final Timestamp timestamp;
  final Timestamp updateTimestamp;
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Assignment(
      teamId: '',
      id: doc.id,
      title: data['title'] ?? '',
      timestamp: data['timestamp'] ?? '',
      updateTimestamp: data['updateTimestamp'] ?? '',
    );
  }
}
