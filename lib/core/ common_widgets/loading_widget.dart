import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.white.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor)),
      ),
    );
  }
}
