import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/screens/home/widget/play_button_widget.dart';

import '../../../data/models/exercise_model.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final Function() onTap;

  const ExerciseItem({
    required this.onTap,
    required this.exercise,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                    color: Colors.black.withOpacity(0.1))
              ],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(exercise.coverImgUrl),
                  fit: BoxFit.cover)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (exercise.goals.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConstants.secondaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      child: Center(
                          child: Text(
                        "${exercise.goals[0]}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.textWhite),
                      )),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                exercise.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: ColorConstants.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.access_time,
                              color: ColorConstants.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${exercise.durationInMins} mins",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: ColorConstants.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: PlayButtonWidget(),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
