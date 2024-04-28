import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';

part 'work_stats_event.dart';
part 'work_stats_state.dart';

class WorkStatsBloc extends Bloc<WorkStatsEvent, WorkStatsState> {
  final WorkEntryRepository _workEntryRepository;

  WorkStatsBloc(this._workEntryRepository) : super(WorkStatsLoading()) {
    on<ShowDailyStats>(_onShowDailyStats);
    on<ShowMonthlyStats>(_onShowMonthlyStats);
    on<ShowSelectedRangeStats>(_onShowSelectedRangeStats);
  }

  /// Gestore dell'evento `ShowDailyStats`.
  ///
  /// Quando viene ricevuto l'evento `ShowDailyStats`, questo metodo recupera le statistiche giornaliere
  /// dal repository delle voci di lavoro utilizzando il metodo `getDailyWorkStats()`.
  ///
  /// Se il recupero delle statistiche ha successo, viene emesso lo stato `WorkStatsLoaded` contenente le statistiche giornaliere
  /// e le altre statistiche precedentemente caricate (mensili e per intervallo selezionato).
  /// In caso di errore durante il recupero delle statistiche, viene emesso lo stato `WorkStatsError` con un messaggio di errore.
  void _onShowDailyStats(
      ShowDailyStats event, Emitter<WorkStatsState> emit) async {
    emit(WorkStatsLoading());
    try {
      final dailyStats = await _workEntryRepository.getDailyWorkStats();
      emit(WorkStatsLoaded(
        dailyStats: dailyStats,
        monthlyStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).monthlyStats
            : [],
        selectedRangeStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedRangeStats
            : [],
        selectedView: StatsView.daily,
        selectedStartDate: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedStartDate
            : DateTime.now().subtract(const Duration(days: 7)),
        selectedEndDate: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedEndDate
            : DateTime.now(),
      ));
    } catch (e) {
      emit(WorkStatsError('Failed to load daily stats: ${e.toString()}'));
    }
  }

  /// Gestore dell'evento `ShowMonthlyStats`.
  ///
  /// Quando viene ricevuto l'evento `ShowMonthlyStats`, questo metodo recupera le statistiche mensili
  /// dal repository delle voci di lavoro utilizzando il metodo `getMonthlyWorkStats()`.
  ///
  /// Se il recupero delle statistiche ha successo, viene emesso lo stato `WorkStatsLoaded` contenente le statistiche mensili
  /// e le altre statistiche precedentemente caricate (giornaliere e per intervallo selezionato).
  /// In caso di errore durante il recupero delle statistiche, viene emesso lo stato `WorkStatsError` con un messaggio di errore.
  void _onShowMonthlyStats(
      ShowMonthlyStats event, Emitter<WorkStatsState> emit) async {
    emit(WorkStatsLoading());
    try {
      final monthlyStats = await _workEntryRepository.getMonthlyWorkStats();
      emit(WorkStatsLoaded(
        dailyStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).dailyStats
            : [],
        monthlyStats: monthlyStats,
        selectedRangeStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedRangeStats
            : [],
        selectedView: StatsView.monthly,
        selectedStartDate: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedStartDate
            : DateTime.now().subtract(const Duration(days: 7)),
        selectedEndDate: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).selectedEndDate
            : DateTime.now(),
      ));
    } catch (e) {
      emit(WorkStatsError('Failed to load monthly stats: ${e.toString()}'));
    }
  }

  /// Gestore dell'evento `ShowSelectedRangeStats`.
  ///
  /// Quando viene ricevuto l'evento `ShowSelectedRangeStats`, questo metodo recupera le statistiche per l'intervallo di date selezionato
  /// dal repository delle voci di lavoro utilizzando il metodo `getSelectedRangeWorkStats()`.
  ///
  /// Se il recupero delle statistiche ha successo, viene emesso lo stato `WorkStatsLoaded` contenente le statistiche per l'intervallo selezionato
  /// e le altre statistiche precedentemente caricate (giornaliere e mensili).
  /// In caso di errore durante il recupero delle statistiche, viene emesso lo stato `WorkStatsError` con un messaggio di errore.
  void _onShowSelectedRangeStats(
      ShowSelectedRangeStats event, Emitter<WorkStatsState> emit) async {
    emit(WorkStatsLoading());
    try {
      final selectedRangeStats =
          await _workEntryRepository.getSelectedRangeWorkStats(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(WorkStatsLoaded(
        dailyStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).dailyStats
            : [],
        monthlyStats: state is WorkStatsLoaded
            ? (state as WorkStatsLoaded).monthlyStats
            : [],
        selectedRangeStats: selectedRangeStats,
        selectedView: StatsView.selectedRange,
        selectedStartDate: event.startDate,
        selectedEndDate: event.endDate,
      ));
    } catch (e) {
      emit(WorkStatsError(
          'Failed to load selected range stats: ${e.toString()}'));
    }
  }
}
