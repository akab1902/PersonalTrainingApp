import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final int durationInMins;
  final String coverImgUrl;
  final String videoUrl;
  final String description;
  final List<dynamic> steps;
  final List<dynamic> goals;

  const Exercise(
      {required this.id,
      required this.name,
      required this.description,
      required this.durationInMins,
      required this.coverImgUrl,
      required this.videoUrl,
      required this.steps,
      required this.goals});

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['durationInMins'] = durationInMins;
    data['coverImgUrl'] = coverImgUrl;
    data['videoUrl'] = videoUrl;
    data['steps'] = steps;
    data['goals'] = goals;
    return data;
  }

  factory Exercise.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Exercise(
        id: snapshot.id,
        name: data?['name'],
        durationInMins: data?['durationInMins'] ?? -1,
        coverImgUrl: data?['coverImgUrl'] ?? "",
        goals: data?['goals'] ?? [],
        steps: (data?['steps'] as List).map((item) => item as String).toList(),
        description: data?['description'],
        videoUrl: data?['videoUrl']);
  }
}
