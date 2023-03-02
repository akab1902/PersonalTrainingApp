
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/service/logger.dart';
import 'camera_utils.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState>{
  final CameraUtils cameraUtils;
  final ResolutionPreset resolutionPreset;
  final CameraLensDirection cameraLensDirection;

  CameraController? _controller;

  CameraBloc({required this.cameraUtils, this.resolutionPreset = ResolutionPreset.high, this.cameraLensDirection = CameraLensDirection.front}) : super(CameraInitial()) {
    on<CameraInitialized>(_onCameraInitialized);
    on<CameraStartRecording>(_onCameraStartRecording);
    on<CameraStopRecording>(_onCameraStopRecording);
  }

  CameraController? getController() => _controller;

  Future<void> _onCameraInitialized(CameraInitialized event, Emitter<CameraState> emit) async {
    try {
      _controller = await cameraUtils.getCameraController(resolutionPreset, cameraLensDirection);
      await _controller?.initialize();
      emit(CameraReadyState());
    } on CameraException catch(error) {
      _controller?.dispose();
      emit(ErrorState(message: error.description ?? "Camera Initialization Error"));
    } catch (error) {
      emit(ErrorState(message: error.toString()));
    }
  }

  Future<void> _onCameraStartRecording(CameraStartRecording event, Emitter<CameraState> emit) async {
    if(state is CameraReadyState){
      startVideoRecording();
      startTimer();
    }
  }

  Future<void> _onCameraStopRecording(CameraStopRecording event, Emitter<CameraState> emit) async {
    if(state is CameraRecordingInProgressState){
      stopVideoRecording();
      stopTimer();
      //save video and exercise data
    }
  }

  void startTimer() {

  }

  void stopTimer() {

  }

  void stopVideoRecording() async {
    try {
      XFile videoFile = await _controller!.stopVideoRecording();
      logger.d(videoFile.path);
      emit(CameraRecordingSuccessState());
    } on CameraException catch(error) {
      emit(ErrorState(message: error.description ?? "Error while Stop Recording"));
    } catch(error) {
      emit(ErrorState(message: error.toString()));
    }
  }

  void startVideoRecording() async {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      emit(ErrorState(message: "Controller is not initialized"));
    }
    if (cameraController!.value.isRecordingVideo) {
      emit(ErrorState(message: "Controller is already recording"));
    }

    try {
      logger.d("Starting recording");
      await cameraController.startVideoRecording();
      logger.d("Started recording");
      emit(CameraRecordingInProgressState());
    } on CameraException catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}