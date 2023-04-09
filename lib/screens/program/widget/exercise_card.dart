import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_training_app/core/const/path_constants.dart';

import '../../../core/const/color_constants.dart';
import '../../../data/models/exercise_model.dart';
import '../bloc/program_bloc.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({required this.exercise, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProgramBloc>(context);
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          )
        ],
      ),
      child: BlocBuilder<ProgramBloc, ProgramState>(
          buildWhen: (_, currState) => currState is ExerciseTappedEvent,
          builder: (context, state) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                bloc.add(ExerciseTappedEvent(exercise: exercise));
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(exercise.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(exercise.description,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                          const SizedBox(height: 3),
                          Text("${exercise.durationInMins} minutes",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                        ])),
                    const SizedBox(width: 60),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: exercise.coverImgUrl == ""
                            ? Image.asset(
                                PathConstants.exercisePlaceholder,
                                fit: BoxFit.fill,
                              )
                            : Image.network(exercise.coverImgUrl,
                                fit: BoxFit.fill),
                      ),
                    ),
                  ])),
            );
          }),
    );
  }
}
