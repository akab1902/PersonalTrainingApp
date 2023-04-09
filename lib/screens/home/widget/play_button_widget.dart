import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: ColorConstants.primaryColor,
      ),
      child: const Center(
        child: Icon(
          Icons.play_arrow_rounded,
          size: 35,
          color: ColorConstants.primaryColorLight,
        ),
      ),
    );
  }
}
