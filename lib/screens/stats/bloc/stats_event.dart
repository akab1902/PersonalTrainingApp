part of 'stats_bloc.dart';

@immutable
abstract class StatsEvent {}

class StatsInitialEvent extends StatsEvent {}

class ReloadImageEvent extends StatsEvent {}

class OnProfileTappedEvent extends StatsEvent {}

class ReloadHistoryEvent extends StatsEvent {}
