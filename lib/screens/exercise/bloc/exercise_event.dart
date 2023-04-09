part of 'exercise_bloc.dart';

@immutable
abstract class ExerciseEvent {}

class BackTappedEvent extends ExerciseEvent {}

class PlayTappedEvent extends ExerciseEvent {
  final int time;

  PlayTappedEvent({
    required this.time,
  });
}

class PauseTappedEvent extends ExerciseEvent {
  final int time;

  PauseTappedEvent({
    required this.time,
  });
}

class OnFinishTappedEvent extends ExerciseEvent {
  final Exercise exercise;

  OnFinishTappedEvent({
    required this.exercise,
  });
}
