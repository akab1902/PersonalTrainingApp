import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/path_constants.dart';
import 'package:personal_training_app/core/service/count_service.dart';
import 'package:personal_training_app/data/models/training_record_model.dart';
import 'package:personal_training_app/repositories/training_record_repository.dart';
import 'package:personal_training_app/repositories/user_repository.dart';
import 'package:personal_training_app/screens/camera/widget/camera_dialog.dart';

import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/service/logger.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Duration _duration = const Duration();
  Timer? _timer;
  String _val = 'Squats';
  bool _isRecording = false;
  bool _isLoading = true;
  String timerString = "00:00";
  late CameraController _cameraController;
  late UserRepository userRepo;
  late TrainingRecordRepository trainingRecordRepo;

  @override
  void initState() {
    super.initState();
    userRepo = UserRepository();
    trainingRecordRepo = TrainingRecordRepository();
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
                  _createTimer(),
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
        isDense: true,
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorConstants.primaryColor,
          ),
        ),
        buttonStyleData: const ButtonStyleData(width: 130),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_up, color: ColorConstants.white),
        ),
        onChanged: !_isRecording
            ? (value) {
                setState(() {
                  _val = value!.toString();
                });
              }
            : null,
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
              color: ColorConstants.white),
          child: Icon(
            _isRecording ? Icons.stop : Icons.play_arrow,
            size: 40,
            color: ColorConstants.primaryColor,
          )),
    );
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return SizedBox(
      width: 90,
      child: Text(
        "$minutes:$seconds",
        textAlign: TextAlign.right,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: ColorConstants.textWhite),
      ),
    );
  }

  String getTimerString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
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
    _cameraController = CameraController(front, ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    try {
      if (_isRecording && _cameraController.value.isInitialized) {
        setState(() {
          timerString = getTimerString();
        });
        stopTimer();
        stopVideoRecording().then((XFile? file) async {
          if (mounted) {
            setState(() {});
          }
          if (file != null) {
            showAnalyzingDialog();
            logger.i("Stopped recording ${file.path}");
            var data = await sendToBackend(file);
            int count;
            if (data != null && data['repetitions'] != null) {
              count = data['repetitions'];
              Navigator.of(context).pop();
              showDialogWithResults(context, count);
            } else {
              Navigator.of(context).pop();
              showDialogWithError(context, "Failed to analyze the video");
            }
          } else {
            showDialogWithError(context, "Recorded File is null");
            logger.e("Recorded File is null");
          }
        });
        setState(() => _isRecording = false);
      } else if (_cameraController.value.isInitialized) {
        startTimer();
        startVideoRecording().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
        logger.i("Started recording");
        setState(() => _isRecording = true);
      }
    } on Exception catch (e) {
      logger.e(e);
      _isRecording = false;
      setState(() {});
      showDialogWithError(context, e.toString());
    }
  }

  showAnalyzingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: 50,
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.primaryColor)),
                    SizedBox(height: 30),
                    Text(
                      "Analyzing the video...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  showDialogWithResults(BuildContext context, int count) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CameraDialog(
            count: count,
            timeString: timerString,
            exerciseName: _val,
            onSave: () => saveResult(count, _val, timerString),
          );
        });
  }

  showDialogWithError(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                width: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error_outline_rounded,
                          color: ColorConstants.errorColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ERROR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Future<bool?> saveResult(int count, String exerciseName, String time) async {
    try {
      String exerciseId;
      if (exerciseName == "Pull-ups") {
        exerciseId = PathConstants.pullUpExerciseId;
      } else if (exerciseName == "Push-ups") {
        exerciseId = PathConstants.pushUpExerciseId;
      } else {
        exerciseId = PathConstants.squatsExerciseId;
      }
      TrainingRecord record = TrainingRecord(
          exerciseName: exerciseName,
          date: DateTime.now(),
          exerciseId: exerciseId,
          count: count,
          durationInSeconds: getDurationInSeconds(time).toInt());

      final recordId = await trainingRecordRepo.createTrainingRecord(record);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      if (recordId != null) {
        final response = await userRepo.addTrainingRecord(userId, recordId);
        if (response == null) {
          throw Exception(["Failed to add Training Record to user history"]);
        } else {
          Navigator.of(context).pop();
        }
      } else {
        throw Exception(["Failed to create Training Record"]);
      }
    } on Exception catch (e) {
      logger.e("Failed to save training record");
      showDialogWithError(context, e.toString());
    }
    return null;
  }

  double getDurationInSeconds(String time) {
    double seconds = 0.00;
    seconds +=
        int.parse(time.substring(0, 2)) * 60 + int.parse(time.substring(3));
    return seconds;
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController cameraController = _cameraController;

    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController cameraController = _cameraController;

    if (!cameraController.value.isInitialized) {
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
      rethrow;
    }
  }

  sendToBackend(file) async {
    CountService backend = CountService();
    Map<String, dynamic>? data =
        await backend.getCountFromVideo(file, "mobileUser");
    return data;
  }
}
