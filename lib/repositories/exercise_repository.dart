import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/service/logger.dart';
import '../data/models/exercise_model.dart';

class ExerciseRepository {
  static final ExerciseRepository _instance = ExerciseRepository._internal();
  final _db = FirebaseFirestore.instance;

  factory ExerciseRepository() {
    return _instance;
  }

  ExerciseRepository._internal();

  getExercises() async {
    try {
      final ref = _db.collection("exercises").withConverter(
            fromFirestore: Exercise.fromFirestore,
            toFirestore: (Exercise exercise, _) => exercise.toSnapshot(),
          );
      List<Exercise> exercises = [];
      var querySnapshot = await ref.get();
      for (var docSnapshot in querySnapshot.docs) {
        final program = docSnapshot.data();
        exercises.add(program);
      }
      return exercises;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  getExercise(String id) async {
    try {
      final ref = _db.collection("exercises").doc(id).withConverter(
            fromFirestore: Exercise.fromFirestore,
            toFirestore: (Exercise exercise, _) => exercise.toSnapshot(),
          );
      var querySnapshot = await ref.get();
      final exercise = querySnapshot.data();
      return exercise;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }
}
