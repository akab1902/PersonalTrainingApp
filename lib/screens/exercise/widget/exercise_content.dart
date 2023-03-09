import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/screens/exercise/widget/step_item.dart';

import '../../../core/const/color_constants.dart';
import '../../../data/models/exercise_model.dart';
import '../bloc/exercise_bloc.dart';
import 'exercise_video.dart';

class ExerciseContent extends StatelessWidget {
  final Exercise exercise;

  const ExerciseContent({
    required this.exercise,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorConstants.white,
      child: SafeArea(
        child: _createDetailedExercise(context),
      ),
    );
  }

  Widget _createDetailedExercise(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader(context),
          const SizedBox(height: 23),
          _createVideo(context),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(children: [
              const SizedBox(height: 9),
              _createDescription(),
              const SizedBox(height: 30),
              _createSteps(),
            ]),
          ),
          // _createTimeTracker(context),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    final bloc = BlocProvider.of<ExerciseBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 8),
      child: GestureDetector(
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            return Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstants.black,
                ),
                const SizedBox(width: 17),
                Text(
                  '${exercise.name} ',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textBlack),
                ),
              ],
            );
          },
        ),
        onTap: () {
          bloc.add(BackTappedEvent());
        },
      ),
    );
  }

  Widget _createVideo(BuildContext context) {
    final bloc = BlocProvider.of<ExerciseBloc>(context);
    return Container(
      height: 235,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
      ),
      child: ExerciseVideo(
        exercise: exercise,
        onPlayTapped: (time) async {
          bloc.add(PlayTappedEvent(time: time));
        },
        onPauseTapped: (time) {
          bloc.add(PauseTappedEvent(time: time));
        },
      ),
    );
  }

  Widget _createDescription() {
    return Text(exercise.description ?? "",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
  }

  Widget _createSteps() {
    return Column(
      children: [
        for (int i = 0; i < exercise.steps!.length; i++) ...[
          StepItem(number: "${i + 1}", description: exercise.steps == null ? "": exercise.steps![i]),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
