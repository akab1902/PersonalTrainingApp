import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class RecordButton extends StatefulWidget {
  bool isRecording = false;
  final Function() onStart;
  final Function() onStop;

  RecordButton({
    required this.onStart,
    required this.onStop,
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
        if(widget.isRecording){
          widget.onStop();
        } else {
          widget.onStart();
        }
        setState(() {
          widget.isRecording = !widget.isRecording;
        });
        },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: ColorConstants.white
        ),
        child: widget.isRecording
            ? const Icon(
          Icons.stop,
          size: 40,
          color: ColorConstants.primaryColor,
        ) : const Icon(
          Icons.play_arrow,
          size: 40,
          color: ColorConstants.primaryColor,
        ),
      ),
    );
  }
}
