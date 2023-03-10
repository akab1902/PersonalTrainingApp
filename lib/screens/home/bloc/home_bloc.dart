import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/program_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(HomeInitial()) {
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<OnExerciseTappedEvent>(_onExerciseTapped);
    on<OnProgramTappedEvent>(_onProgramTapped);
    on<HomeInitialEvent>(_onHomeInitialized);
    on<ReloadDisplayNameEvent>(_onReloadDisplayName);
    on<ReloadCalendarEvent>(_onReloadCalendar);
    on<ReloadImageEvent>(_onReloadImage);
    on<ReloadSuggestedProgramsEvent>(_onReloadSuggested);
    on<ReloadTodaySessionEvent>(_onReloadTodaySession);
  }

  void _onProfileTapped(OnProfileTappedEvent event, Emitter<HomeState> emit){
    emit(NextProfilePageState());
  }

  void _onExerciseTapped(OnExerciseTappedEvent event, Emitter<HomeState> emit){
    emit(NextExercisePageState(exercise: event.exercise));
  }

  void _onProgramTapped(OnProgramTappedEvent event, Emitter<HomeState> emit){
    emit(NextProgramPageState(programName: event.programName));
  }

  void _onHomeInitialized(HomeInitialEvent event, Emitter<HomeState> emit){
    // get workouts and other data
  }

  void _onReloadDisplayName(ReloadDisplayNameEvent event, Emitter<HomeState> emit){
    //get name from db
    emit(ReloadDisplayNameState(displayName: 'User01'));
  }

  void _onReloadCalendar(ReloadCalendarEvent event, Emitter<HomeState> emit){
    DateTime today = DateTime.now();
    var days;
    if(today.month == 2) {
      days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
    } else if(today.month == 4 || today.month == 6 || today.month == 9 ||today.month == 11){
      days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
    } else {
      days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
    }
    emit(ReloadCalendarState(today: today.day, days: days));
  }

  void _onReloadSuggested(ReloadSuggestedProgramsEvent event, Emitter<HomeState> emit){
    //get suggested from db
    emit(ReloadSuggestedProgramsState(suggestedPrograms: [
      Program(id: '1', name: 'Legs', durationInDays: 20, coverImgUrl: 'https://mensfitness.co.uk/wp-content/uploads/sites/2/2020/05/Side-to-side-lunge.jpg?w=900'),
      Program(id: '1', name: 'Full body', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Arms', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Back', durationInDays: 1, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg'),
      Program(id: '1', name: 'Shoulders', durationInDays: 20, coverImgUrl: 'https://mensfitness.co.uk/wp-content/uploads/sites/2/2020/05/Side-to-side-lunge.jpg?w=900'),
    ]));
  }

  void _onReloadTodaySession(ReloadTodaySessionEvent event, Emitter<HomeState> emit){
    //get suggested from db
    emit(ReloadTodaySessionState(todaySessions: [
      Exercise(id: '1', name: 'Legs', durationInMins: 20, coverImgUrl: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/young-bodybuilder-doing-pushups-at-the-outdoor-gym-royalty-free-image-1661874908.jpg?crop=1.00xw:1.00xh;0,0&resize=640:*', videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4", description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ', steps: ['Stand up', 'Sit down', 'Lay down']),
      Exercise(id: '2', name: 'Full body', durationInMins: 10, coverImgUrl: 'https://assets.gqindia.com/photos/5cee7eb00379a73d25177759/4:3/w_1440,h_1080,c_limit/Pushup.jpg', videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4", description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ', steps: ['Stand up', 'Sit down', 'Lay down']),
      ]));
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<HomeState> emit) async {
    //get photo from backend/db
    String? photoURL = "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
    emit(ReloadImageState(photoURL: photoURL));
  }
}