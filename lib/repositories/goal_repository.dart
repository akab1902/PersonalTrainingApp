import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/service/logger.dart';
import '../data/models/goal_model.dart';

class GoalRepository {
  static final GoalRepository _instance = GoalRepository._internal();
  final _db = FirebaseFirestore.instance;

  factory GoalRepository() {
    return _instance;
  }

  GoalRepository._internal();

  getGoals() async {
    try {
      final ref = _db.collection("goals").withConverter(
            fromFirestore: Goal.fromFirestore,
            toFirestore: (Goal goal, _) => goal.toSnapshot(),
          );
      List<Goal> goals = [];
      var querySnapshot = await ref.get();
      for (var docSnapshot in querySnapshot.docs) {
        final goal = docSnapshot.data();
        goals.add(goal);
      }
      return goals;
    } on Exception catch (e) {
      logger.e(e);
      return [];
    }
  }
}
