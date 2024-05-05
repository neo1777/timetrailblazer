import 'package:equatable/equatable.dart';

/// La classe base astratta per gli stati del BLoC `WorkStatsBloc`.
abstract class WorkStatsState extends Equatable {
  const WorkStatsState();

  @override
  List<Object?> get props => [];
}

/// Lo stato che indica che le statistiche di lavoro sono in caricamento.
class WorkStatsLoading extends WorkStatsState {}

/// Lo stato che indica che le statistiche di lavoro sono state caricate con successo.
class WorkStatsLoaded extends WorkStatsState {
  /// Lista delle statistiche per l'intervallo selezionato.
  final List<DailyWorkStats> selectedRangeStats;

  const WorkStatsLoaded({required this.selectedRangeStats});

  @override
  List<Object?> get props => [selectedRangeStats];
}

/// Lo stato che indica un errore durante il caricamento delle statistiche di lavoro.
class WorkStatsError extends WorkStatsState {
  /// Messaggio di errore.
  final String message;

  const WorkStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Classe che rappresenta le statistiche di lavoro giornaliere.
class DailyWorkStats {
  /// Data delle statistiche.
  final DateTime date;

  /// Durata delle ore lavorate.
  final Duration workedHours;

  /// Durata delle ore di straordinario.
  final Duration overtimeHours;

  DailyWorkStats(
      {required this.date,
      required this.workedHours,
      required this.overtimeHours});
}
