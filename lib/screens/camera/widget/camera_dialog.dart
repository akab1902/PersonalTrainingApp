import 'package:flutter/material.dart';
import 'package:personal_training_app/core/%20common_widgets/custom_button.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class CameraDialog extends StatelessWidget {
  final int count;
  final String exerciseName;
  final String timeString;
  final Future<void> Function() onSave;

  const CameraDialog(
      {required this.count,
      required this.exerciseName,
      required this.timeString,
      required this.onSave,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Spacer(),
              const Text(
                "RESULT",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.clear_rounded)),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text.rich(TextSpan(
              text: "Exercise: ",
              style: const TextStyle(
                  color: ColorConstants.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              children: [
                TextSpan(
                  text: " $exerciseName",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                )
              ])),
          const SizedBox(
            height: 10,
          ),
          Text.rich(TextSpan(
              text: "Count: ",
              style: const TextStyle(
                  color: ColorConstants.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              children: [
                TextSpan(
                  text: " $count",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                )
              ])),
          const SizedBox(
            height: 10,
          ),
          Text.rich(TextSpan(
              text: "Time: ",
              style: const TextStyle(
                  color: ColorConstants.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              children: [
                TextSpan(
                  text: " $timeString",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                )
              ])),
          const SizedBox(
            height: 25,
          ),
          CustomButton(
              title: "Save",
              bgColor: ColorConstants.primaryColor,
              onTap: () => onSave())
        ],
      ),
    );
  }
}
