part of 'signin_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInButtonEnableChangedState extends SignInState {
  final bool isEnabled;

  SignInButtonEnableChangedState({
    required this.isEnabled,
  });
}

class ShowErrorState extends SignInState {}

class ErrorState extends SignInState {
  final String message;

  ErrorState({required this.message});
}

class NextHomePageState extends SignInState {}

class NextSignUpPageState extends SignInState {}

class LoadingState extends SignInState {}
