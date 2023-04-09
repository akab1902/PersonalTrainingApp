import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_training_app/data/models/bar_chart_data_model.dart';
import 'package:personal_training_app/data/models/training_record_model.dart';
import 'package:personal_training_app/repositories/training_record_repository.dart';
import '../../../core/service/logger.dart';
import '../../../data/models/user_model.dart' as user_model;

import '../../../repositories/exercise_repository.dart';
import '../../../repositories/program_repository.dart';
import '../../../repositories/user_repository.dart';

part 'stats_state.dart';

part 'stats_event.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial()) {
    on<StatsInitialEvent>(_onStatsInitialized);
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<ReloadImageEvent>(_onReloadImage);
    on<ReloadHistoryEvent>(_onReloadHistory);
  }

  String photoUrl = "";
  UserRepository userRepo = UserRepository();
  ProgramRepository programRepo = ProgramRepository();
  ExerciseRepository exerciseRepo = ExerciseRepository();
  TrainingRecordRepository trainingRecordsRepo = TrainingRecordRepository();
  List<TrainingRecord> history = [];
  List<BarChartDataItem> lastWeekHistory = [];

  Future<void> _onStatsInitialized(
      StatsInitialEvent event, Emitter<StatsState> emit) async {
    emit(LoadingState());
    // get user details
    user_model.User currentUser =
        await userRepo.getUser(FirebaseAuth.instance.currentUser!.uid);
    photoUrl = currentUser.photoUrl;
    history
      ..clear()
      ..addAll(await getHistory(currentUser.history));
    lastWeekHistory
      ..clear()
      ..addAll(await getLastWeekHistory(history));

    emit(InitialLoaded());
  }

  void _onProfileTapped(OnProfileTappedEvent event, Emitter<StatsState> emit) {
    emit(NextProfilePageState());
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<StatsState> emit) async {
    emit(ReloadImageState(photoURL: photoUrl));
  }

  void _onReloadHistory(
      ReloadHistoryEvent event, Emitter<StatsState> emit) async {
    emit(
        ReloadHistoryState(history: history, lastWeekHistory: lastWeekHistory));
  }

  getHistory(List<String> ids) async {
    List<TrainingRecord> result = [];
    for (String s in ids) {
      TrainingRecord? e = await trainingRecordsRepo.getRecord(s);
      if (e != null) {
        result.add(e);
      } else {
        logger.e("Failed to get training record with id: $s");
      }
    }
    return result;
  }

  getLastWeekHistory(List<TrainingRecord> records) async {
    List<BarChartDataItem> result = [];
    final seconds = [0, 0, 0, 0, 0, 0, 0];
    DateTime today = DateTime.now();
    final days = [
      today.subtract(const Duration(days: 6)),
      today.subtract(const Duration(days: 5)),
      today.subtract(const Duration(days: 4)),
      today.subtract(const Duration(days: 3)),
      today.subtract(const Duration(days: 2)),
      today.subtract(const Duration(days: 1)),
      today
    ];
    for (TrainingRecord r in records) {
      if (isSameDay(r.date, today)) {
        seconds[6] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[5])) {
        seconds[5] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[4])) {
        seconds[4] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[3])) {
        seconds[3] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[2])) {
        seconds[2] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[1])) {
        seconds[1] += r.durationInSeconds;
      } else if (isSameDay(r.date, days[0])) {
        seconds[0] += r.durationInSeconds;
      }
    }
    for (int i = 0; i < seconds.length; i++) {
      result.add(BarChartDataItem(
        label: DateFormat('EEEE').format(days[i]),
        label2: DateFormat('d MMM').format(days[i]),
        bottomLabel: DateFormat('EEEE').format(days[i]).substring(0, 1),
        id: i,
        val: (seconds[i] / 60).toDouble(),
      ));
    }
    return result;
  }

  isSameDay(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }
}
