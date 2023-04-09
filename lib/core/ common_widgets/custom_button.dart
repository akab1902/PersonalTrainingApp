import 'package:flutter/material.dart';

import '../const/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;
  final Color bgColor;
  final Color textColor;

  const CustomButton(
      {super.key,
      required this.title,
      this.isEnabled = true,
      required this.onTap,
      this.bgColor = ColorConstants.secondaryColor,
      this.textColor = ColorConstants.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isEnabled ? bgColor : ColorConstants.disabledColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: isEnabled ? onTap : () {},
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
