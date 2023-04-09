import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_training_app/data/models/training_record_model.dart';

import '../core/service/logger.dart';

class TrainingRecordRepository {
  static final TrainingRecordRepository _instance =
      TrainingRecordRepository._internal();
  final _db = FirebaseFirestore.instance;

  factory TrainingRecordRepository() {
    return _instance;
  }

  TrainingRecordRepository._internal();

  createTrainingRecord(TrainingRecord record) async {
    final result = await _db
        .collection("trainingRecords")
        .add(record.toSnapshot())
        .catchError((error, stackTrace) {
      logger.e(error.toString());
      return null;
    });
    return result.id;
  }

  getRecord(String id) async {
    try {
      final ref = _db.collection("trainingRecords").doc(id).withConverter(
            fromFirestore: TrainingRecord.fromFirestore,
            toFirestore: (TrainingRecord record, _) => record.toSnapshot(),
          );
      var querySnapshot = await ref.get();
      final record = querySnapshot.data();
      return record;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }
}
