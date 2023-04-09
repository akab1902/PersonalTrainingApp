import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:personal_training_app/data/models/training_record_model.dart';
import 'package:personal_training_app/repositories/training_record_repository.dart';
import 'package:personal_training_app/repositories/user_repository.dart';

import '../../../core/service/logger.dart';
import '../../../data/models/exercise_model.dart';
import '../../../repositories/exercise_repository.dart';

part 'exercise_event.dart';

part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseInitial()) {
    on<BackTappedEvent>(_onBackTapped);
    on<PlayTappedEvent>(_onPlayTapped);
    on<PauseTappedEvent>(_onPauseTapped);
    on<OnFinishTappedEvent>(_onFinishTapped);
  }

  int time = 0;

  UserRepository userRepo = UserRepository();
  ExerciseRepository exerciseRepo = ExerciseRepository();
  TrainingRecordRepository trainingRecordRepo = TrainingRecordRepository();

  void _onBackTapped(BackTappedEvent event, Emitter<ExerciseState> emit) {
    emit(BackTappedState());
  }

  void _onPlayTapped(PlayTappedEvent event, Emitter<ExerciseState> emit) {
    time = event.time;
    emit(PlayTimerState(time: event.time));
  }

  void _onPauseTapped(PauseTappedEvent event, Emitter<ExerciseState> emit) {
    time = event.time;
    emit(PauseTimerState(currentTime: event.time));
  }

  Future<void> _onFinishTapped(
      OnFinishTappedEvent event, Emitter<ExerciseState> emit) async {
    Exercise exercise = event.exercise;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final response = await addTrainingRecord(userId, exercise);
    if (response != null) {
      emit(FinishTappedState(enabled: false));
      emit(FinishSuccessState(success: true));
    } else {
      emit(FinishSuccessState(success: false));
      logger.e("Failed to finish the exercise with response: $response");
    }
  }

  addTrainingRecord(String userId, Exercise exercise) async {
    TrainingRecord record = TrainingRecord(
        date: DateTime.now(),
        exerciseName: exercise.name,
        exerciseId: exercise.id,
        durationInSeconds: exercise.durationInMins * 60);
    final recordId = await trainingRecordRepo.createTrainingRecord(record);
    if (recordId != null) {
      final finishExerciseResponse =
          await userRepo.finishExercise(userId, exercise.id);
      if (finishExerciseResponse != null) {
        final addRecordResponse =
            await userRepo.addTrainingRecord(userId, recordId);
        if (addRecordResponse == null) {
          return null;
        }
      } else {
        return null;
      }
    }
    return true;
  }
}
