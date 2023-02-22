import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/service/auth_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(HomeInitial()) {
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<OnExerciseTappedEvent>(_onExerciseTapped);
    on<HomeInitialEvent>(_onHomeInitialized);
    on<ReloadDisplayNameEvent>(_onReloadDisplayName);
    on<ReloadImageEvent>(_onReloadImage);
  }

  void _onProfileTapped(OnProfileTappedEvent event, Emitter<HomeState> emit){
    emit(NextProfilePageState());
  }

  void _onExerciseTapped(OnExerciseTappedEvent event, Emitter<HomeState> emit){
    emit(NextExercisePageState(exerciseId: event.exerciseId));
  }

  void _onHomeInitialized(HomeInitialEvent event, Emitter<HomeState> emit){
    // get workouts and other data
  }

  void _onReloadDisplayName(ReloadDisplayNameEvent event, Emitter<HomeState> emit){
    //get name from db
    emit(ReloadDisplayNameState(displayName: 'User01'));
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<HomeState> emit) async {
    //get photo from backend/db
    String? photoURL = "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
    emit(ReloadImageState(photoURL: photoURL));
  }
}