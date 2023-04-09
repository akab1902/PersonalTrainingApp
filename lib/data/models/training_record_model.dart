import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingRecord {
  final String? id;
  final String exerciseName;
  final DateTime date;
  final String exerciseId;
  final int? count;
  final int durationInSeconds;

  TrainingRecord({
    this.id,
    required this.exerciseName,
    required this.date,
    required this.exerciseId,
    this.count,
    required this.durationInSeconds,
  });

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['exerciseId'] = exerciseId;
    data['count'] = count;
    data['exerciseName'] = exerciseName;
    data['durationInSeconds'] = durationInSeconds;
    return data;
  }

  factory TrainingRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TrainingRecord(
        date: (data?['date'] as Timestamp).toDate(),
        exerciseId: data?['exerciseId'],
        exerciseName: data?['exerciseName'],
        count: data?['count'],
        durationInSeconds: data?['durationInSeconds']);
  }
}
