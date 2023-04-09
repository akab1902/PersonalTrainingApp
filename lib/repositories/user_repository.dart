import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_training_app/data/models/user_model.dart';

import '../core/service/logger.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  final _db = FirebaseFirestore.instance;

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  createUser(String id, User user) async {
    await _db.collection("users").doc(id).set(user.toSnapshot()).then((value) {
      logger.i("added data with ID: $id");
      return value;
    }).catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
  }

  getUser(String id) async {
    try {
      final ref = _db.collection("users").doc(id).withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toSnapshot(),
          );
      var querySnapshot = await ref.get();
      final user = querySnapshot.data();
      return user;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<bool?> addProgram(String id, String programId) async {
    await _db.collection("users").doc(id).update({
      "currentPrograms": FieldValue.arrayUnion([programId])
    }).then((value) {
      logger.i("added program with ID: $programId");
    }).catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
    return true;
  }

  Future<bool?> addExercise(String id, String exerciseId) async {
    await _db.collection("users").doc(id).update({
      "currentExercises": FieldValue.arrayUnion([exerciseId])
    }).then((value) {
      logger.i("added exercise with ID: $exerciseId");
    }).catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
    return true;
  }

  Future<bool?> addTrainingRecord(String id, String trainingRecordId) async {
    await _db.collection("users").doc(id).update({
      "history": FieldValue.arrayUnion([trainingRecordId])
    }).then((value) {
      logger.i("added trainingRecord with ID: $trainingRecordId");
    }).catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
    return true;
  }

  Future<bool?> finishExercise(String id, String exerciseId) async {
    await _db.collection("users").doc(id).update({
      "currentExercises": FieldValue.arrayRemove([exerciseId])
    }).then((value) {
      logger.i("finished currentExercise with ID: $exerciseId");
    }).catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
    return true;
  }
}
