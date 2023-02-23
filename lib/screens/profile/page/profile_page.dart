import 'package:flutter/material.dart';

import '../../../core/const/color_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
        onTap: (){
      Navigator.pop(context);
    },
    child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: const Text(
            'Profile Page',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textBlack),
          ),
        )
    ));
  }
}
