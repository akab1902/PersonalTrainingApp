import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? id;
  final String name;

  const Goal({
    required this.name,
    this.id,
  });

  Map<String, dynamic> toSnapshot() {
    return {
      "name": name,
    };
  }

  factory Goal.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Goal(
      name: data?['name'],
    );
  }
}
