import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/user_model.dart' as user_model;

import '../../../core/service/auth_service.dart';
import '../../../repositories/user_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<OnSignOutTapped>(_onSignOutTapped);
    on<OnProfileInitialized>(_onProfileInitialized);
  }

  String userName = "User";
  String photoUrl = "";
  String dateOfBirth = "";
  String email = "";
  String gender = "";
  List<String> goals = [];
  double? height;
  double? weight;
  double? bmi;
  UserRepository userRepo = UserRepository();

  Future<void> _onSignOutTapped(
      OnSignOutTapped event, Emitter<ProfileState> emit) async {
    try {
      await AuthService.signOut();
      emit(NextSignOutState());
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void _onProfileInitialized(
      OnProfileInitialized event, Emitter<ProfileState> emit) async {
    try {
      emit(LoadingState());
      user_model.User currentUser =
          await userRepo.getUser(FirebaseAuth.instance.currentUser!.uid);
      userName = currentUser.username;
      photoUrl = currentUser.photoUrl;
      dateOfBirth = DateFormat('yyyy-MM-dd').format(currentUser.dateOfBirth);
      email = currentUser.email;
      gender = currentUser.gender;
      height = currentUser.height;
      weight = currentUser.weight;
      bmi = currentUser.bmi;
      goals = currentUser.goals;
      emit(InitialLoaded());
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
