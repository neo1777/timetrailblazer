import 'package:timetrailblazer/data/models/work_entry_dto.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La classe `WorkEntryMapper` mappa le entità `WorkEntry` in oggetti `WorkEntryDTO` e viceversa.
class WorkEntryMapper {
  /// Mappa un oggetto `WorkEntryDTO` in un'entità `WorkEntry`.
  WorkEntry fromDTO(WorkEntryDTO dto) {
    try {
      return WorkEntry(
        id: dto.id,
        timestamp: dto.timestamp,
        isEntry: dto.isEntry,
      );
    } catch (e) {
      logger.e('Errore durante la mappatura da WorkEntryDTO a WorkEntry',
          error: e);
      throw Exception(
          'Errore durante la mappatura da WorkEntryDTO a WorkEntry: ${e.toString()}. Si prega di verificare i dati del DTO e contattare l\'assistenza se il problema persiste.');
    }
  }

  /// Mappa un'entità `WorkEntry` in un oggetto `WorkEntryDTO`.
  WorkEntryDTO toDTO(WorkEntry entry) {
    try {
      return WorkEntryDTO(
        id: entry.id,
        timestamp: entry.timestamp,
        isEntry: entry.isEntry,
      );
    } catch (e) {
      logger.e('Errore durante la mappatura da WorkEntry a WorkEntryDTO',
          error: e);
      throw Exception(
          'Errore durante la mappatura da WorkEntry a WorkEntryDTO: ${e.toString()}. Si prega di verificare i dati dell\'entità WorkEntry e contattare l\'assistenza se il problema persiste.');
    }
  }
}
