import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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

  void _onCameraStartRecording(CameraStartRecording event, Emitter<CameraState> emit){
    if(state is CameraReadyState){
      emit(CameraRecordingInProgressState());
      try {
        //
      } on CameraException catch(error) {
        emit(ErrorState(message: error.description ?? "Error while Recording"));
      }
    }
  }

  void _onCameraStopRecording(CameraStopRecording event, Emitter<CameraState> emit){
    _controller!.dispose();
    emit(CameraRecordingSuccessState());
  }
}