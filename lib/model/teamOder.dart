import 'package:cloud_firestore/cloud_firestore.dart';

class TeamOrder {
  final String teamId;
  final int order;

  TeamOrder({required this.teamId, required this.order});

  factory TeamOrder.fromFirestore(DocumentSnapshot doc) {
    return TeamOrder(
      teamId: doc.id,
      order: doc['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
    };
  }
}
