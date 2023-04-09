import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/service/auth_service.dart';
import '../../../core/service/validation_service.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<OnTextChangedEvent>(_onTextChanged);
    on<OnSignUpTappedEvent>(_signUpTapped);
    on<OnSignInTappedEvent>(_signInTapped);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isButtonEnabled = false;

  void _onTextChanged(
      OnTextChangedEvent event, Emitter<SignInState> emit) async {
    if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
      isButtonEnabled = checkIfSignUpButtonEnabled();
      emit(SignInButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  void _signInTapped(
      OnSignInTappedEvent event, Emitter<SignInState> emit) async {
    if (checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        await AuthService.signIn(emailController.text, passwordController.text);
        emit(NextHomePageState());
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(ShowErrorState());
    }
  }

  void _signUpTapped(
      OnSignUpTappedEvent event, Emitter<SignInState> emit) async {
    emit(NextSignUpPageState());
  }

  bool checkIfSignUpButtonEnabled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text);
  }
}
