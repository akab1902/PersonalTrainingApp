import 'package:flutter/material.dart';

import '../const/color_constants.dart';

class CustomTag extends StatelessWidget {
  final Icon? icon;
  final String content;

  const CustomTag({super.key, this.icon, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorConstants.primaryColor.withOpacity(0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          const SizedBox(width: 7),
          Text(content,
              style: const TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
