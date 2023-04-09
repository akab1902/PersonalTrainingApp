import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:personal_training_app/repositories/exercise_repository.dart';
import 'package:personal_training_app/repositories/program_repository.dart';
import 'package:personal_training_app/repositories/user_repository.dart';

import '../../../core/service/logger.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/program_model.dart';

part 'program_event.dart';

part 'program_state.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  ProgramBloc() : super(ProgramInitial()) {
    on<ProgramInitialEvent>(_onProgramInitial);
    on<AddTappedEvent>(_onAddTapped);
    on<ExerciseTappedEvent>(_onExerciseTapped);
  }

  Program? curProgram;
  List<Exercise> exercises = [];
  UserRepository userRepo = UserRepository();
  ProgramRepository programRepo = ProgramRepository();
  ExerciseRepository exerciseRepo = ExerciseRepository();

  Future<void> _onProgramInitial(
      ProgramInitialEvent event, Emitter<ProgramState> emit) async {
    //get exercises
    curProgram = event.program;
    logger.i(curProgram?.name);
    exercises
      ..clear()
      ..addAll(await getExercises(curProgram!.exercises));
    emit(ReloadExercisesState(exercises: exercises));
    emit(AddButtonChangedState(enabled: true));
  }

  Future<void> _onAddTapped(
      AddTappedEvent event, Emitter<ProgramState> emit) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (await addProgram(userId, curProgram!)) {
      logger.i("Add program is successful!");
      emit(AddButtonChangedState(enabled: false));
      emit(AddSuccessState(success: true));
    } else {
      emit(AddSuccessState(success: false));
    }
  }

  void _onExerciseTapped(
      ExerciseTappedEvent event, Emitter<ProgramState> emit) {
    emit(ExerciseTappedState(exercise: event.exercise));
  }

  Future<List<Exercise>> getExercises(List<String> ids) async {
    List<Exercise> result = [];
    for (String s in ids) {
      Exercise? e = await exerciseRepo.getExercise(s);
      if (e != null) {
        result.add(e);
      } else {
        logger.e("Failed to get exercise with id: $s");
      }
    }
    return result;
  }

  Future<bool> addProgram(String id, Program program) async {
    final programResponse = await userRepo.addProgram(id, program.id);
    if (programResponse == null || programResponse == false) {
      logger.e(
          "Failed to add program with id: $id. Program response: $programResponse}");
      return false;
    } else {
      final response = await addExercises(id, program.exercises);
      return response;
    }
  }

  Future<bool> addExercises(String id, List<String> exerciseIds) async {
    for (String s in exerciseIds) {
      final response = await userRepo.addExercise(id, s);
      if (response == null) {
        logger.e("Failed to add exercise with id: $s}");
        return false;
      }
    }
    return true;
  }
}
