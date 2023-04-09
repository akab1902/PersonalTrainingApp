part of 'program_bloc.dart';

@immutable
abstract class ProgramState {}

class ProgramInitial extends ProgramState {}

class ExerciseTappedState extends ProgramState {
  final Exercise exercise;

  ExerciseTappedState({required this.exercise});
}

class ReloadExercisesState extends ProgramState {
  final List<Exercise> exercises;

  ReloadExercisesState({
    required this.exercises,
  });
}

class AddSuccessState extends ProgramState {
  final bool success;

  AddSuccessState({
    required this.success,
  });
}

class AddButtonChangedState extends ProgramState {
  final bool enabled;

  AddButtonChangedState({
    required this.enabled,
  });
}
