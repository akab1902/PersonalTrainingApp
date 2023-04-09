import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

import '../../../data/models/program_model.dart';

class ProgramItem extends StatelessWidget {
  final Program program;
  final Function() onTap;

  const ProgramItem({
    required this.onTap,
    required this.program,
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
                image: program.coverImgUrl == ''
                    ? const AssetImage(
                            "assets/placeholders/exercise_placeholder.png")
                        as ImageProvider
                    : NetworkImage(program.coverImgUrl),
                fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.all(15.0),
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
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    program.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      color: ColorConstants.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${program.durationInDays} days",
                  style: const TextStyle(
                    color: ColorConstants.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
