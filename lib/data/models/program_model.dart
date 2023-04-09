import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  final String id;
  final String name;
  final int durationInDays;
  final String coverImgUrl;
  final List<String> goals;
  final List<String> exercises;

  const Program({
    required this.id,
    required this.name,
    required this.durationInDays,
    required this.coverImgUrl,
    required this.goals,
    required this.exercises,
  });

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['durationInDays'] = durationInDays;
    data['coverImgUrl'] = coverImgUrl;
    data['goals'] = goals;
    data['exercises'] = exercises;
    return data;
  }

  factory Program.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Program(
        id: snapshot.id,
        name: data?['name'],
        durationInDays: data?['durationInDays'] ?? -1,
        coverImgUrl: data?['coverImgUrl'] ?? "",
        goals: List.from(data?['goals'] ?? []),
        exercises: List.from(data?['exercises'] ?? []));
  }
}
