part of 'program_bloc.dart';

@immutable
abstract class ProgramEvent {}

class ExerciseTappedEvent extends ProgramEvent {
  final Exercise exercise;

  ExerciseTappedEvent({required this.exercise});
}

class AddTappedEvent extends ProgramEvent {}

class ProgramInitialEvent extends ProgramEvent {
  final Program program;

  ProgramInitialEvent({required this.program});
}
