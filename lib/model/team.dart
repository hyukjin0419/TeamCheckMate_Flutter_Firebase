import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  Team({
    required this.id,
    required this.creatorUid,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.updateTimestamp,
  });

  final String id;
  final String creatorUid;
  final String title;
  final String description;
  final Timestamp timestamp;
  final Timestamp updateTimestamp;
}
