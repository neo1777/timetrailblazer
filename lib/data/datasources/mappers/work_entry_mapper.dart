import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// La classe `WorkEntryMapper` si occupa di mappare tra `WorkEntryDTO` e `WorkEntry`.
class WorkEntryMapper {
  /// Mappa un oggetto `WorkEntryDTO` in un oggetto `WorkEntry`.
  ///
  /// Accetta un parametro [dto] di tipo `WorkEntryDTO`.
  ///
  /// Restituisce un nuovo oggetto `WorkEntry` inizializzato con i valori del DTO.
  WorkEntryModel fromDTO(WorkEntryDTO dto) {
    return WorkEntryModel(
      id: dto.id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(dto.timestamp),
      isEntry: dto.isEntry == 1,
    );
  }

  /// Mappa un oggetto `WorkEntry` in un oggetto `WorkEntryDTO`.
  ///
  /// Accetta un parametro [model] di tipo `WorkEntry`.
  ///
  /// Restituisce un nuovo oggetto `WorkEntryDTO` inizializzato con i valori del modello.
  WorkEntryDTO toDTO(WorkEntryModel model) {
    return WorkEntryDTO(
      id: model.id,
      timestamp: model.timestamp.millisecondsSinceEpoch,
      isEntry: model.isEntry! ? 1 : 0,
    );
  }
}
