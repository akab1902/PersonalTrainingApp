import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/data/models/user_model.dart'
    as user_model;
import 'package:personal_training_app/repositories/user_repository.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/validation_service.dart';
import '../../../data/models/goal_model.dart';
import '../../../repositories/goal_repository.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<OnTextChangedEvent>(_onTextChanged);
    on<SignUpTappedEvent>(_signUpTapped);
    on<LoginTappedEvent>(_loginTapped);
    on<SignUpInitialEvent>(_onSignUpInitialized);
  }

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final genderController = TextEditingController();
  final List<Goal> goals = [];
  final List<String> selectedGoals = [];
  final userRepo = UserRepository();
  final goalRepo = GoalRepository();

  bool isButtonEnabled = false;

  void _onTextChanged(
      OnTextChangedEvent event, Emitter<SignupState> emit) async {
    if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
      isButtonEnabled = checkIfSignUpButtonEnabled();
      emit(SignUpButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  void _onSignUpInitialized(
      SignUpInitialEvent event, Emitter<SignupState> emit) async {
    emit(LoadingState());
    goals
      ..clear
      ..addAll(await goalRepo.getGoals());
    emit(LoadedState());
  }

  void _signUpTapped(SignUpTappedEvent event, Emitter<SignupState> emit) async {
    if (checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        final result = await AuthService.signUp(emailController.text,
            passwordController.text, userNameController.text);
        await userRepo.createUser(
            result.uid,
            user_model.User(
                username: userNameController.text,
                email: emailController.text,
                password: passwordController.text,
                dateOfBirth: DateTime.parse(dobController.text),
                weight: double.parse(weightController.text),
                height: double.parse(heightController.text),
                gender: genderController.text,
                bmi: calculateBMI(double.parse(weightController.text),
                    double.parse(heightController.text)),
                goals: selectedGoals,
                history: [],
                currentExercises: [],
                photoUrl: "",
                currentPrograms: []));
        emit(NextLoginPageState());
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
        confirmPasswordController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        selectedGoals.isNotEmpty &&
        dobController.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.username(userNameController.text) &&
        ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text) &&
        ValidationService.confirmPassword(
            passwordController.text, confirmPasswordController.text) &&
        ValidationService.onlyDouble(heightController.text) &&
        ValidationService.onlyDouble(weightController.text) &&
        ValidationService.onlyLetters(genderController.text);
  }

  double calculateBMI(double weight, double height) {
    return double.parse(
        (weight / (height / 100 * height / 100)).toStringAsFixed(1));
  }
}
