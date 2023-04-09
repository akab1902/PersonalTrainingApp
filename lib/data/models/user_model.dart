import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class User {
  final String username;
  final String photoUrl;
  final String email;
  final String? id;
  final String password;
  final DateTime dateOfBirth;
  final double weight;
  final double height;
  final String gender;
  final double bmi;
  final List<String> history;
  final List<String> goals;
  final List<String> currentExercises;
  final List<String> currentPrograms;

  User(
      {required this.username,
      required this.email,
      this.id,
      required this.password,
      required this.dateOfBirth,
      required this.weight,
      required this.height,
      required this.gender,
      required this.bmi,
      required this.history,
      required this.goals,
      required this.photoUrl,
      required this.currentExercises,
      required this.currentPrograms});

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['photoUrl'] = photoUrl;
    data['email'] = email;
    data['password'] = password;
    data['dateOfBirth'] = DateFormat('yyyy-MM-dd').format(dateOfBirth);
    data['weight'] = weight;
    data['height'] = height;
    data['gender'] = gender;
    data['bmi'] = bmi;
    data['history'] = history;
    data['goals'] = goals;
    data['history'] = history;
    data['currentExercises'] = currentExercises;
    data['currentPrograms'] = currentPrograms;
    return data;
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      username: data?['username'],
      email: data?['email'],
      password: data?['password'],
      dateOfBirth: DateTime.parse(data?['dateOfBirth']),
      weight: data?['weight'],
      height: data?['height'],
      gender: data?['gender'],
      bmi: data?['bmi'],
      photoUrl: data?['photoUrl'] ?? "",
      goals: List.from(data?['goals'] ?? []),
      history: List.from(data?['history'] ?? []),
      currentExercises: List.from(data?['currentExercises'] ?? []),
      currentPrograms: List.from(data?['currentPrograms'] ?? []),
    );
  }
}
