import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class RecordButton extends StatefulWidget {
  bool isRecording = false;
  final Function() onTap;

  RecordButton({
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap;
        setState(() {
          widget.isRecording = !widget.isRecording;
        });
        },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: ColorConstants.white
        ),
        child: widget.isRecording
            ? const Icon(
          Icons.stop,
          color: ColorConstants.primaryColor,
        ) : const Icon(
          Icons.play_arrow,
          color: ColorConstants.primaryColor,
        ),
      ),
    );
  }
}
