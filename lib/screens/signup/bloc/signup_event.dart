part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class OnTextChangedEvent extends SignupEvent {}

class SignUpInitialEvent extends SignupEvent {}

class SignUpTappedEvent extends SignupEvent {}

class LoginTappedEvent extends SignupEvent {}
