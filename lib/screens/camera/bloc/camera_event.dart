part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class CameraInitialized extends CameraEvent {}
class CameraStopped extends CameraEvent {}
class CameraStartRecording extends CameraEvent {}
class CameraStopRecording extends CameraEvent {}


