import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';

class StepItem extends StatelessWidget {
  final String number;
  final String description;

  const StepItem({required this.number, required this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorConstants.primaryColor.withOpacity(0.12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(description)),
      ],
    );
  }
}
