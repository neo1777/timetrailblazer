part of 'work_stats_bloc.dart';

abstract class WorkStatsEvent extends Equatable {
  const WorkStatsEvent();

  @override
  List<Object> get props => [];
}

/// Evento per mostrare le statistiche giornaliere.
class ShowDailyStats extends WorkStatsEvent {}

/// Evento per mostrare le statistiche mensili.
class ShowMonthlyStats extends WorkStatsEvent {}

/// Evento per mostrare le statistiche per l'intervallo selezionato.
class ShowSelectedRangeStats extends WorkStatsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ShowSelectedRangeStats({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}



