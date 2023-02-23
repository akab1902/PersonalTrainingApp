import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';

class ProgramPage extends StatelessWidget {
  final String programName;

  const ProgramPage({
    required this.programName,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Text(
              '$programName Program Page',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textBlack),
            ),
          ),
        )
    );
  }
}
