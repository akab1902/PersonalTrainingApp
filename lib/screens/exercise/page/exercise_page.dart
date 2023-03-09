import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/exercise/bloc/exercise_bloc.dart';
import 'package:personal_training_app/screens/exercise/widget/exercise_content.dart';

import '../../../data/models/exercise_model.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;

  const ExercisePage({required this.exercise, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<ExerciseBloc> _buildBody(BuildContext context) {
    return BlocProvider<ExerciseBloc>(
      create: (context) => ExerciseBloc(),
      child: BlocConsumer<ExerciseBloc, ExerciseState>(
        buildWhen: (_, currState) => currState is ExerciseInitial,
        builder: (context, state) {
          return ExerciseContent(exercise: exercise);
        },
        listenWhen: (_, currState) => currState is BackTappedState,
        listener: (context, state) {
          if (state is BackTappedState) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
