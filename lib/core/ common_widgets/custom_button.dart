import 'package:flutter/material.dart';

import '../const/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;

  const CustomButton({super.key, required this.title, this.isEnabled = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: isEnabled ? ColorConstants.secondaryColor : ColorConstants.disabledColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: ColorConstants.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}