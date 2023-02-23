import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/program_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(HomeInitial()) {
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<OnExerciseTappedEvent>(_onExerciseTapped);
    on<HomeInitialEvent>(_onHomeInitialized);
    on<ReloadDisplayNameEvent>(_onReloadDisplayName);
    on<ReloadImageEvent>(_onReloadImage);
    on<ReloadSuggestedProgramsEvent>(_onReloadSuggested);
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

  void _onReloadSuggested(ReloadSuggestedProgramsEvent event, Emitter<HomeState> emit){
    //get suggested from db
    emit(ReloadSuggestedProgramsState(suggestedPrograms: [
      Program(id: '1', name: 'Legs', durationInDays: 20, coverImgUrl: 'https://mensfitness.co.uk/wp-content/uploads/sites/2/2020/05/Side-to-side-lunge.jpg?w=900'),
      Program(id: '1', name: 'Full body', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Full body', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Full body', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Legs', durationInDays: 20, coverImgUrl: 'https://mensfitness.co.uk/wp-content/uploads/sites/2/2020/05/Side-to-side-lunge.jpg?w=900'),
    ]));
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<HomeState> emit) async {
    //get photo from backend/db
    String? photoURL = "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
    emit(ReloadImageState(photoURL: photoURL));
  }
}