import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 50, left: 20),
          child: const Text(
            'Stats Page',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textBlack),
          ),
        )
    );
  }
}
