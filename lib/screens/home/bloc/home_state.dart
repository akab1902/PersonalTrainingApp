part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState{}

class ShowErrorState extends HomeState {}

class ErrorState extends HomeState {
  final String message;

  ErrorState({required this.message});
}

class NextExercisePageState extends HomeState {
  final String exerciseId;

  NextExercisePageState({required this.exerciseId});
}

class NextProgramPageState extends HomeState {
  final String programName;

  NextProgramPageState({required this.programName});
}

class NextProfilePageState extends HomeState {}

class LoadingState extends HomeState {}

class ReloadImageState extends HomeState {
  final String? photoURL;

  ReloadImageState({
    required this.photoURL,
  });
}

class ReloadDisplayNameState extends HomeState {
  final String? displayName;

  ReloadDisplayNameState({
    required this.displayName,
  });
}

class ReloadSuggestedProgramsState extends HomeState {
  final List<Program>? suggestedPrograms;

  ReloadSuggestedProgramsState({
    required this.suggestedPrograms,
  });
}