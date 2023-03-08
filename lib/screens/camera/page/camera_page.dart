import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:personal_training_app/screens/camera/widget/record_button_widget.dart';

import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/service/logger.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Duration _duration = Duration();
  Timer? _timer;
  String _val = 'Squats';
  bool _isRecording = false;
  bool _isLoading = true;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cameraContent();
  }

  Widget cameraContent() {
    return Container(
      width: double.infinity,
      color: ColorConstants.backgroundWhite,
      child: Stack(
        children: [
          !_isLoading
              ? SizedBox(
              height: double.infinity,
              child: CameraPreview(_cameraController))
              : _createLoading(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _createDropDownMenu(),
                  _createButton(),
                  _createTimer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDropDownMenu() {
    final items = ['Squats', 'Push-ups', 'Pull-ups'];
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ))
            .toList(),
        value: _val,
        dropdownStyleData: DropdownStyleData(
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorConstants.primaryColor,
          ),
        ),
        buttonStyleData: const ButtonStyleData(width: 130),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_up, color: ColorConstants.white),
        ),
        onChanged: (value) {
          setState(() {
            _val = value!;
          });
        },
      ),
    );
  }

  Widget _createButton() {
    return RecordButton(
                isRecording: _isRecording,
                onStart: () {
                  _recordVideo();
                  startTimer();
                  // bloc.add(CameraStartRecording());
                },
                onStop: () {
                  _recordVideo();
                  stopTimer();
                  // bloc.add(CameraStopRecording());
                });
  }

  Widget _createLoading(){
    return const LoadingWidget();
  }

  Widget _createTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Text(
      "$minutes:$seconds",
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: ColorConstants.textWhite),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    setState(() {
      _duration = const Duration();
      _timer?.cancel();
    });
  }

  void addTime() {
    setState(() {
      final seconds = _duration.inSeconds + 1;
      _duration = Duration(seconds: seconds);
    });
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      logger.d(file.name);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }
}
