part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignUpButtonEnableChangedState extends SignupState {
  final bool isEnabled;

  SignUpButtonEnableChangedState({
    required this.isEnabled,
  });
}

class ShowErrorState extends SignupState {}

class ErrorState extends SignupState {
  final String message;

  ErrorState({required this.message});
}

class NextLoginPageState extends SignupState {}

class LoadingState extends SignupState {}

class LoadedState extends SignupState {}
