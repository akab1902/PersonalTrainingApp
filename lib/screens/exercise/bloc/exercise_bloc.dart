import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'exercise_event.dart';

part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseInitial()) {
    on<BackTappedEvent>(_onBackTapped);
    on<PlayTappedEvent>(_onPlayTapped);
    on<PauseTappedEvent>(_onPauseTapped);
  }

  int time = 0;

  void _onBackTapped(BackTappedEvent event, Emitter<ExerciseState> emit) {
    emit(BackTappedState());
  }

  void _onPlayTapped(PlayTappedEvent event, Emitter<ExerciseState> emit) {
    time = event.time;
    emit(PlayTimerState(time: event.time));
  }

  void _onPauseTapped(PauseTappedEvent event, Emitter<ExerciseState> emit) {
    time = event.time;
    emit(PauseTimerState(currentTime: event.time));
  }
}
