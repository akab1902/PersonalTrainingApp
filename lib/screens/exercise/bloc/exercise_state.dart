part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class BackTappedState extends ExerciseState {}

class FinishTappedState extends ExerciseState {
  final bool enabled;

  FinishTappedState({
    required this.enabled,
  });
}

class FinishSuccessState extends ExerciseState {
  final bool success;

  FinishSuccessState({
    required this.success,
  });
}

class PlayTimerState extends ExerciseState {
  final int time;

  PlayTimerState({
    required this.time,
  });
}

class PauseTimerState extends ExerciseState {
  final int currentTime;

  PauseTimerState({
    required this.currentTime,
  });
}
