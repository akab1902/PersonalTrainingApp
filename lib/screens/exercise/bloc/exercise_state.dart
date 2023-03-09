part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class BackTappedState extends ExerciseState {}

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