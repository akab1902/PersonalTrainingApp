part of 'camera_bloc.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState{}

class ShowErrorState extends CameraState {}

class ErrorState extends CameraState {
  final String message;

  ErrorState({required this.message});
}

class CameraReadyState extends CameraState {}
class CameraRecordingSuccessState extends CameraState {}
class CameraRecordingInProgressState extends CameraState {}
class CameraRecordingErrorState extends CameraState {}

