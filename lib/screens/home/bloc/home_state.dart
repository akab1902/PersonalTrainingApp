part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class InitialLoaded extends HomeState {}

class ShowErrorState extends HomeState {}

class ErrorState extends HomeState {
  final String message;

  ErrorState({required this.message});
}

class NextExercisePageState extends HomeState {
  final Exercise exercise;

  NextExercisePageState({required this.exercise});
}

class NextProgramPageState extends HomeState {
  final Program program;

  NextProgramPageState({required this.program});
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

class ReloadOtherProgramsState extends HomeState {
  final List<Program>? otherPrograms;

  ReloadOtherProgramsState({
    required this.otherPrograms,
  });
}

class ReloadTodaySessionState extends HomeState {
  final List<Exercise>? todaySessions;

  ReloadTodaySessionState({
    required this.todaySessions,
  });
}
