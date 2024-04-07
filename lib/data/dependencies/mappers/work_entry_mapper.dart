import 'package:timetrailblazer/data/models/work_entry_dto.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';

/// La classe `WorkEntryMapper` mappa le entità `WorkEntry` in oggetti `WorkEntryDTO` e viceversa.
class WorkEntryMapper {
  /// Mappa un oggetto `WorkEntryDTO` in un'entità `WorkEntry`.
  WorkEntry fromDTO(WorkEntryDTO dto) {
    return WorkEntry(
      id: dto.id,
      timestamp: dto.timestamp,
      isEntry: dto.isEntry,
    );
  }

  /// Mappa un'entità `WorkEntry` in un oggetto `WorkEntryDTO`.
  WorkEntryDTO toDTO(WorkEntry entry) {
    return WorkEntryDTO(
      id: entry.id,
      timestamp: entry.timestamp,
      isEntry: entry.isEntry,
    );
  }
}
