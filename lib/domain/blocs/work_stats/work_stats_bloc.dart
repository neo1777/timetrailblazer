import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/domain/blocs/work_stats/work_stats_event.dart';
import 'package:timetrailblazer/domain/blocs/work_stats/work_stats_state.dart';

/// La classe `WorkStatsBloc` gestisce la logica di business per le statistiche di lavoro.
class WorkStatsBloc extends Bloc<WorkStatsEvent, WorkStatsState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `WorkStatsBloc`.
  ///
  /// Accetta il repository delle voci di lavoro come parametro.
  /// Inizializza lo stato iniziale a [WorkStatsLoading] e registra i gestori degli eventi utilizzando il metodo `on`.
  WorkStatsBloc(this.workEntryRepository) : super(WorkStatsLoading()) {
    on<ShowSelectedRangeStats>(_onShowSelectedRangeStats);
  }

  /// Gestore dell'evento `ShowSelectedRangeStats`.
  ///
  /// Quando viene ricevuto l'evento `ShowSelectedRangeStats`, questo metodo recupera le statistiche per l'intervallo di date selezionato
  /// dal repository delle voci di lavoro utilizzando il metodo `getSelectedRangeWorkStats()`.
  ///
  /// Se il recupero delle statistiche ha successo, viene emesso lo stato `WorkStatsLoaded` contenente le statistiche per l'intervallo selezionato.
  /// In caso di errore durante il recupero delle statistiche, viene emesso lo stato `WorkStatsError` con un messaggio di errore.
  Future<void> _onShowSelectedRangeStats(
      ShowSelectedRangeStats event, Emitter<WorkStatsState> emit) async {
    emit(WorkStatsLoading());
    try {
      final selectedRangeStats =
          await workEntryRepository.getSelectedRangeWorkStats(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(WorkStatsLoaded(selectedRangeStats: selectedRangeStats));
    } catch (e) {
      emit(WorkStatsError(
          'Failed to load selected range stats: ${e.toString()}'));
    }
  }
}