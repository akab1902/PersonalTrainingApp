part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class OnSignOutTapped extends ProfileEvent {}

class OnProfileInitialized extends ProfileEvent {}
