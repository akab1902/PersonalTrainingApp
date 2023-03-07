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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: ColorConstants.black,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    '$programName Page',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textBlack),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildBody(context)
          ],
        ));
  }

  Widget _buildBody(BuildContext context){
    return Container();
  }
}
