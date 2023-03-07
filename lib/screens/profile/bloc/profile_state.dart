part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState{}

class ShowErrorState extends ProfileState {}

class ErrorState extends ProfileState {
  final String message;

  ErrorState({required this.message});
}

class NextSignOutState extends ProfileState {}