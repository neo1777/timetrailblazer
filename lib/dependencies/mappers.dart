import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';

/// Restituisce una lista di `SingleChildWidget` per l'iniezione dei mapper nell'albero dei widget.
///
/// Questa funzione configura i mapper necessari per l'applicazione, creandoli quando necessario.
/// I mapper sono responsabili della mappatura tra le entità di dominio e gli oggetti di trasferimento dati (DTO).
/// Utilizza l'approccio "lazy" per creare i mapper solo quando vengono effettivamente richiesti.
///
/// Returns:
/// - Una lista di `SingleChildWidget` contenente i mapper configurati.
List<SingleChildWidget> getMappers() {
  return [
    // Fornisce il `WorkEntryMapper` all'albero dei widget, creandolo quando necessario.
    // Il `WorkEntryMapper` è responsabile della mappatura tra `WorkEntry` e `WorkEntryDTO`.
    // Utilizza l'approccio "lazy" per creare il mapper solo quando viene effettivamente richiesto.
    Provider<WorkEntryMapper>(
      create: (_) => WorkEntryMapper(),
      lazy: true,
    ),
  ];
}