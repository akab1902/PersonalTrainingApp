part of 'stats_bloc.dart';

@immutable
abstract class StatsState {}

class StatsInitial extends StatsState {}

class InitialLoaded extends StatsState {}

class ErrorState extends StatsState {
  final String message;

  ErrorState({required this.message});
}

class LoadingState extends StatsState {}

class NextProfilePageState extends StatsState {}

class ReloadImageState extends StatsState {
  final String? photoURL;

  ReloadImageState({
    required this.photoURL,
  });
}

class ReloadHistoryState extends StatsState {
  final List<TrainingRecord>? history;
  final List<BarChartDataItem>? lastWeekHistory;

  ReloadHistoryState({
    required this.history,
    required this.lastWeekHistory,
  });
}
