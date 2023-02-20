import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorConstants.black,
      child: Center(
        child: Theme(
          data: ThemeData(cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark)),
          child: const CupertinoActivityIndicator(radius: 17),
        ),
      ),
    );
  }
}
