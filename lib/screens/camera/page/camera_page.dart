import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          child: const Text(
            'Camera Page',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textBlack),
          ),
        )
    );
  }
}
