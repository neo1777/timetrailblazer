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
  /// Lista delle statistiche giornaliere.
  final List<DailyWorkStats> dailyStats;

  /// Lista delle statistiche mensili.
  final List<MonthlyWorkStats> monthlyStats;

  /// Lista delle statistiche per l'intervallo selezionato.
  final List<DailyWorkStats> selectedRangeStats;

  /// Visualizzazione delle statistiche selezionata.
  final StatsView selectedView;

  /// Data di inizio dell'intervallo selezionato.
  final DateTime selectedStartDate;

  /// Data di fine dell'intervallo selezionato.
  final DateTime selectedEndDate;

  const WorkStatsLoaded({
    required this.dailyStats,
    required this.monthlyStats,
    required this.selectedRangeStats,
    required this.selectedView,
    required this.selectedStartDate,
    required this.selectedEndDate,
  });

  @override
  List<Object?> get props => [
        dailyStats,
        monthlyStats,
        selectedRangeStats,
        selectedView,
        selectedStartDate,
        selectedEndDate,
      ];
}

/// Lo stato che indica un errore durante il caricamento delle statistiche di lavoro.
class WorkStatsError extends WorkStatsState {
  /// Messaggio di errore.
  final String message;

  const WorkStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Enum per le possibili visualizzazioni delle statistiche.
enum StatsView {
  daily,
  monthly,
  selectedRange,
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

/// Classe che rappresenta le statistiche di lavoro mensili.
class MonthlyWorkStats {
  /// Mese delle statistiche.
  final DateTime month;

  /// Durata delle ore lavorate.
  final Duration workedHours;

  /// Durata delle ore di straordinario.
  final Duration overtimeHours;

  MonthlyWorkStats(
      {required this.month,
      required this.workedHours,
      required this.overtimeHours});
}
