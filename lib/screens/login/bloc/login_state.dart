part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginButtonEnableChangedState extends LoginState {
  final bool isEnabled;

  LoginButtonEnableChangedState({
    required this.isEnabled,
  });
}

class ShowErrorState extends LoginState {}

class ErrorState extends LoginState {
  final String message;

  ErrorState({required this.message});
}

class NextHomePageState extends LoginState {}

class LoadingState extends LoginState {}
