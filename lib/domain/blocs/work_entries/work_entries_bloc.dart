import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';

part 'work_entries_event.dart';
part 'work_entries_state.dart';

/// Il BLoC che gestisce lo stato delle voci di lavoro.
class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  /// Il repository delle voci di lavoro.
  final WorkEntryRepository _workEntryRepository;

  /// Costruttore del BLoC.
  ///
  /// Inizializza lo stato iniziale del BLoC a `WorkEntriesInitial`.
  /// Riceve come dipendenza il [WorkEntryRepository] per interagire con il database.
  WorkEntriesBloc(this._workEntryRepository) : super(WorkEntriesInitial()) {
    /// Gestisce l'evento `FetchWorkEntries`.
    on<FetchWorkEntries>(_onFetchWorkEntries);

    // Aggiungi altri gestori di eventi se necessario
  }

  /// Gestore dell'evento `FetchWorkEntries`.
  ///
  /// Quando viene richiesto il recupero delle voci di lavoro:
  /// 1. Emette lo stato `WorkEntriesLoading` per indicare che è in corso il caricamento.
  /// 2. Genera la lista di giorni compresi tra la data di inizio e la data di fine.
  /// 3. Recupera le voci di lavoro dal repository per i giorni generati.
  /// 4. Emette lo stato `WorkEntriesLoaded` con le voci di lavoro recuperate.
  /// 5. In caso di errore, emette lo stato `WorkEntriesError` con un messaggio di errore.
  Future<void> _onFetchWorkEntries(
      FetchWorkEntries event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      final startDate = event.startDate;
      final endDate = event.endDate;

      // Genera la lista di giorni compresi tra la data di inizio e la data di fine
      final days = List.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      // Recupera le voci di lavoro dal repository per i giorni generati
      final dayWorkEntriesList =
          await _workEntryRepository.getWorkEntriesByDays(
        days,
        endDate,
      );

      emit(WorkEntriesLoaded(dayWorkEntriesList: dayWorkEntriesList));
    } catch (error) {
      emit(const WorkEntriesError(
          message: 'Errore durante il caricamento delle voci di lavoro'));
    }
  }

  // Aggiungi altri metodi per gestire altri eventi se necessario
}
