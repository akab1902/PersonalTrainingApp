import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class HistoryItem extends StatelessWidget {
  final String exerciseName;
  final int durationInSeconds;
  final int? count;
  final String date;

  const HistoryItem(
      {required this.exerciseName,
      required this.durationInSeconds,
      required this.date,
      this.count,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: $exerciseName"),
              const SizedBox(
                height: 10,
              ),
              if (count != null) Text("Count: $count"),
              if (count != null)
                const SizedBox(
                  height: 10,
                ),
              Text("${(durationInSeconds / 60).toStringAsFixed(1)} mins"),
              const SizedBox(
                height: 10,
              ),
              Text(date),
            ],
          ),
        ));
  }
}
