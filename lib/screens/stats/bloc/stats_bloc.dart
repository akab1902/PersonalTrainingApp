import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'stats_state.dart';
part 'stats_event.dart';

class StatsBloc extends Bloc<StatsEvent,StatsState>{
  StatsBloc() : super(StatsInitial()) {
    on<StatsInitialEvent>(_onStatsInitialized);
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<ReloadImageEvent>(_onReloadImage);
  }

  void _onStatsInitialized(StatsInitialEvent event, Emitter<StatsState> emit){
    // get workouts and other data
  }

  void _onProfileTapped(OnProfileTappedEvent event, Emitter<StatsState> emit){
    emit(NextProfilePageState());
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<StatsState> emit) async {
    //get photo from backend/db
    String? photoURL = "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
    emit(ReloadImageState(photoURL: photoURL));
  }
}