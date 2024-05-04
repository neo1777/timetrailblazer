import 'package:equatable/equatable.dart';

/// La classe base astratta per gli eventi del BLoC `WorkStatsBloc`.
abstract class WorkStatsEvent extends Equatable {
  const WorkStatsEvent();

  @override
  List<Object?> get props => [];
}

/// L'evento che richiede di mostrare le statistiche giornaliere.
class ShowDailyStats extends WorkStatsEvent {}

/// L'evento che richiede di mostrare le statistiche mensili.
class ShowMonthlyStats extends WorkStatsEvent {}

/// L'evento che richiede di mostrare le statistiche per l'intervallo selezionato.
class ShowSelectedRangeStats extends WorkStatsEvent {
  /// La data di inizio dell'intervallo selezionato.
  final DateTime startDate;

  /// La data di fine dell'intervallo selezionato.
  final DateTime endDate;

  const ShowSelectedRangeStats(
      {required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
