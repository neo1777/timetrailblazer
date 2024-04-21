import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/datasources/providers/work_entry_provider.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// La classe `WorkEntryRepository` rappresenta il repository per la gestione delle voci di lavoro.
class WorkEntryRepository {
  /// L'istanza di `WorkEntryProvider` utilizzata per l'accesso ai dati.
  final WorkEntryProvider _workEntryProvider;
  
  /// L'istanza di `WorkEntryMapper` utilizzata per la mappatura tra `WorkEntryDTO` e `WorkEntry`.
  final WorkEntryMapper _workEntryMapper;

  /// Costruttore della classe `WorkEntryRepository`.
  ///
  /// Accetta i seguenti parametri:
  /// - [_workEntryProvider]: l'istanza di `WorkEntryProvider` per l'accesso ai dati.
  /// - [_workEntryMapper]: l'istanza di `WorkEntryMapper` per la mappatura.
  WorkEntryRepository(this._workEntryProvider, this._workEntryMapper);

  /// Inserisce una nuova voce di lavoro.
  ///
  /// Accetta un parametro [workEntry] di tipo `WorkEntry` che rappresenta la voce di lavoro da inserire.
  ///
  /// Restituisce un `Future` che si completa quando l'inserimento è terminato.
  Future<void> insertWorkEntry(WorkEntryModel workEntry) async {
    final workEntryDTO = _workEntryMapper.toDTO(workEntry);
    await _workEntryProvider.insertWorkEntry(workEntryDTO);
  }

  /// Recupera l'ultima voce di lavoro inserita.
  ///
  /// Restituisce un `Future` che si completa con un oggetto `WorkEntry` rappresentante l'ultima voce di lavoro,
  /// oppure `null` se non ci sono voci di lavoro.
  Future<WorkEntryModel?> getLastWorkEntry() async {
    final workEntryDTO = await _workEntryProvider.getLastWorkEntry();
    if (workEntryDTO != null) {
      return _workEntryMapper.fromDTO(workEntryDTO);
    }
    return null;
  }

//   /// Questo metodo chiama il metodo getWorkEntriesByDateRange del provider
//   /// WorkEntryProvider passando i timestamp di inizio e di fine convertiti in millisecondi.
//   /// Quindi, mappa i WorkEntryDTO restituiti dal provider in oggetti WorkEntry utilizzando
//   /// il metodo fromDTO del WorkEntryMapper.
//   Future<List<WorkEntry>> getWorkEntriesByDateRange(DateTime startDate, DateTime endDate) async {
//   final workEntryDTOs = await _workEntryProvider.getWorkEntriesByDateRange(
//     startDate.millisecondsSinceEpoch,
//     endDate.millisecondsSinceEpoch,
//   );
//   return workEntryDTOs.map(_workEntryMapper.fromDTO).toList();
// }

Future<List<DayWorkEntriesModel>> getWorkEntriesByDays(List<DateTime> days, DateTime endDate) async {
  final List<DayWorkEntriesModel> dayWorkEntriesList = [];

  for (final day in days) {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    final workEntryDTOs = await _workEntryProvider.getWorkEntriesByDateRange(
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    );

    final workEntries = workEntryDTOs.map(_workEntryMapper.fromDTO).toList();

    dayWorkEntriesList.add(
      DayWorkEntriesModel(
        day: day,
        workEntries: workEntries.isNotEmpty ? workEntries : null,
      ),
    );
  }

  return dayWorkEntriesList;
}
}