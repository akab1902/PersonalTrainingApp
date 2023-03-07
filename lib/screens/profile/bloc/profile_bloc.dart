import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/service/auth_service.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<OnSignOutTapped>(_onSignOutTapped);
  }

  Future<void> _onSignOutTapped(
      OnSignOutTapped event, Emitter<ProfileState> emit) async {
    try {
      await AuthService.signOut();
      emit(NextSignOutState());
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
