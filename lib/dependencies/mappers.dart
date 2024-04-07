import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';

/// Restituisce una lista di `SingleChildWidget` per l'iniezione dei mapper nell'albero dei widget.
List<SingleChildWidget> getMappers() {
  return [
    // Fornisce il `WorkEntryMapper` all'albero dei widget, creandolo quando necessario.
    // Il `WorkEntryMapper` è responsabile della mappatura tra `WorkEntry` e `WorkEntryDTO`.
    Provider<WorkEntryMapper>(
      create: (_) => WorkEntryMapper(),
    ),
  ];
}
