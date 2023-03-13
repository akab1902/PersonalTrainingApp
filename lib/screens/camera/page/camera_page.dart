import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
  Future<void> dispose() async {
    super.dispose();
    await _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorConstants.backgroundWhite,
      child: Stack(
        children: [
          !_isLoading
              ? SizedBox(
              height: double.infinity,
              width: double.infinity,
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
    return GestureDetector(
      onTap: () {
        _recordVideo();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: ColorConstants.white
        ),
        child: Icon(
          _isRecording ? Icons.stop : Icons.play_arrow,
          size: 40,
          color: ColorConstants.primaryColor,
        )
      ),
    );
  }

  Widget _createLoading() {
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
    _cameraController = CameraController(front, ResolutionPreset.high, imageFormatGroup: ImageFormatGroup.yuv420);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    try {
      if (_isRecording && _cameraController.value.isInitialized) {
        stopTimer();
        stopVideoRecording().then((XFile? file) async {
          if (mounted) {
            setState(() {});
          }
          if (file != null) {
            await GallerySaver.saveVideo(file.path);
            File(file.path).deleteSync();
            logger.i("stop recording ${file.path}");
          }
        });
        setState(() => _isRecording = false);
      } else if(_cameraController.value.isInitialized){
        startTimer();
        startVideoRecording().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
        logger.i("start recording");
        setState(() => _isRecording = true);
      }
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      logger.d('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await _cameraController.startVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
      return;
    }
  }
}
