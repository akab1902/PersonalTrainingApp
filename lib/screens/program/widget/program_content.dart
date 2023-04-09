import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/const/path_constants.dart';
import 'package:personal_training_app/screens/program/widget/exercise_card.dart';

import '../../../core/ common_widgets/custom_tag_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/program_model.dart';
import '../bloc/program_bloc.dart';

class ProgramContent extends StatelessWidget {
  final Program program;

  const ProgramContent({required this.program, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.backgroundWhite,
      height: double.infinity,
      width: double.infinity,
      child: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    return BlocBuilder<ProgramBloc, ProgramState>(
      buildWhen: (_, currState) => currState is ReloadExercisesState,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createAppBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _createImage(context),
                      const SizedBox(height: 20),
                      _createDescription(context),
                      const SizedBox(height: 5),
                      _createExerciseList(
                          state is ReloadExercisesState ? state.exercises : []),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _createAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.black,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            program.name,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textBlack),
          ),
        ],
      ),
    );
  }

  Widget _createImage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(
          image: program.coverImgUrl == ""
              ? const AssetImage(PathConstants.exercisePlaceholder)
                  as ImageProvider
              : NetworkImage(program.coverImgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _createDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CustomTag(
            icon: const Icon(
              Icons.access_time,
              color: ColorConstants.primaryColor,
              size: 17,
            ),
            content: "${program.durationInDays} days",
          ),
          const SizedBox(width: 15),
          CustomTag(
            icon: const Icon(
              Icons.sports_martial_arts,
              color: ColorConstants.primaryColor,
              size: 17,
            ),
            content: '${program.exercises.length} exercises',
          ),
        ],
      ),
    );
  }

  Widget _createExerciseList(List<Exercise> exercises) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: exercises.map((e) => ExerciseCard(exercise: e)).toList(),
    );
  }
}
