part of 'signin_bloc.dart';

@immutable
abstract class SignInEvent {}

class OnTextChangedEvent extends SignInEvent {}

class OnSignInTappedEvent extends SignInEvent {}

class OnSignUpTappedEvent extends SignInEvent {}
