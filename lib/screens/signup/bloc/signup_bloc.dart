import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/validation_service.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()){
    on<OnTextChangedEvent>(_onTextChanged);
    on<SignUpTappedEvent>(_signUpTapped);
    on<LoginTappedEvent>(_loginTapped);
  }

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isButtonEnabled = false;

  void _onTextChanged(OnTextChangedEvent event, Emitter<SignupState> emit) async {
    if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
      isButtonEnabled = checkIfSignUpButtonEnabled();
      emit(SignUpButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  void _signUpTapped(SignUpTappedEvent event, Emitter<SignupState> emit) async {
    if (checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        await AuthService.signUp(emailController.text,
            passwordController.text, userNameController.text);
        emit(NextHomePageState());
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(ShowErrorState());
    }
  }

  void _loginTapped(LoginTappedEvent event, Emitter<SignupState> emit) async {
    emit(NextLoginPageState());
  }

  bool checkIfSignUpButtonEnabled() {
    return userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.username(userNameController.text) &&
        ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text) &&
        ValidationService.confirmPassword(passwordController.text, confirmPasswordController.text);
  }
}
