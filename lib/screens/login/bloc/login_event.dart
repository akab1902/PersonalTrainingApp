part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class OnTextChangedEvent extends LoginEvent {}
class OnLoginTappedEvent extends LoginEvent {}
class OnSignUpEvent extends LoginEvent {}
