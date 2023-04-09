import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:personal_training_app/repositories/exercise_repository.dart';
import 'package:personal_training_app/repositories/program_repository.dart';
import 'package:personal_training_app/repositories/user_repository.dart';
import '../../../core/service/logger.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/program_model.dart';
import '../../../data/models/user_model.dart' as user_model;

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<OnProfileTappedEvent>(_onProfileTapped);
    on<OnExerciseTappedEvent>(_onExerciseTapped);
    on<OnProgramTappedEvent>(_onProgramTapped);
    on<HomeInitialEvent>(_onHomeInitialized);
    on<ReloadDisplayNameEvent>(_onReloadDisplayName);
    on<ReloadImageEvent>(_onReloadImage);
    on<ReloadSuggestedProgramsEvent>(_onReloadSuggested);
    on<ReloadOtherProgramsEvent>(_onReloadOthers);
    on<ReloadTodaySessionEvent>(_onReloadTodaySession);
  }

  String userName = "User";
  String photoUrl = "";
  List<Program> suggestedPrograms = [];
  List<Program> otherPrograms = [];
  List<Exercise> todaySessions = [];
  UserRepository userRepo = UserRepository();
  ProgramRepository programRepo = ProgramRepository();
  ExerciseRepository exerciseRepo = ExerciseRepository();

  void _onProfileTapped(OnProfileTappedEvent event, Emitter<HomeState> emit) {
    emit(NextProfilePageState());
  }

  void _onExerciseTapped(OnExerciseTappedEvent event, Emitter<HomeState> emit) {
    emit(NextExercisePageState(exercise: event.exercise));
  }

  void _onProgramTapped(OnProgramTappedEvent event, Emitter<HomeState> emit) {
    emit(NextProgramPageState(program: event.program));
  }

  Future<void> _onHomeInitialized(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(LoadingState());
    // get user details
    user_model.User? currentUser =
        await userRepo.getUser(FirebaseAuth.instance.currentUser!.uid);
    if (currentUser != null) {
      userName = currentUser.username;
      photoUrl = currentUser.photoUrl;
      await filterPrograms(currentUser);
      await getTodaySessions(currentUser.currentExercises);
      emit(InitialLoaded());
    } else {
      logger.e("Failed to get user");
    }
  }

  void _onReloadDisplayName(
      ReloadDisplayNameEvent event, Emitter<HomeState> emit) {
    //get name from db
    emit(ReloadDisplayNameState(displayName: userName));
  }

  void _onReloadSuggested(
      ReloadSuggestedProgramsEvent event, Emitter<HomeState> emit) {
    emit(ReloadSuggestedProgramsState(suggestedPrograms: suggestedPrograms));
  }

  void _onReloadOthers(
      ReloadOtherProgramsEvent event, Emitter<HomeState> emit) {
    emit(ReloadOtherProgramsState(otherPrograms: otherPrograms));
  }

  void _onReloadTodaySession(
      ReloadTodaySessionEvent event, Emitter<HomeState> emit) {
    emit(ReloadTodaySessionState(todaySessions: todaySessions));
  }

  void _onReloadImage(ReloadImageEvent event, Emitter<HomeState> emit) async {
    emit(ReloadImageState(photoURL: photoUrl));
  }

  getTodaySessions(List<String> ids) async {
    List<Exercise> result = [];
    for (String s in ids) {
      Exercise? e = await exerciseRepo.getExercise(s);
      if (e != null) {
        result.add(e);
      } else {
        logger.e("Failed to get exercise with id: $s");
      }
    }
    todaySessions
      ..clear()
      ..addAll(result);
  }

  Future<void> filterPrograms(user_model.User user) async {
    final programs = await programRepo.getPrograms() ?? [];
    final currentPrograms = user.currentPrograms.toSet();
    List<Program> filteredList = [];
    List<Program> otherList = [];
    Set<String> goals = user.goals.toSet();
    for (Program p in programs) {
      if (!currentPrograms.contains(p.id)) {
        if (p.goals.toSet().intersection(goals.toSet()).isNotEmpty) {
          filteredList.add(p);
        } else {
          otherList.add(p);
        }
      }
    }
    otherPrograms
      ..clear()
      ..addAll(otherList);
    suggestedPrograms
      ..clear()
      ..addAll(filteredList);
  }
}
