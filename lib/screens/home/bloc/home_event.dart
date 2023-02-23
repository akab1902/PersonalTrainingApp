part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class OnProfileTappedEvent extends HomeEvent {}

class OnExerciseTappedEvent extends HomeEvent {
  String exerciseId;

  OnExerciseTappedEvent({required this.exerciseId});
}

class HomeInitialEvent extends HomeEvent {}

class ReloadDisplayNameEvent extends HomeEvent {}

class ReloadImageEvent extends HomeEvent {}

class ReloadSuggestedProgramsEvent extends HomeEvent {}
