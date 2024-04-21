import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/datasources/providers/work_entry_provider.dart';

/// Restituisce una lista di `SingleChildWidget` per l'iniezione dei provider nell'albero dei widget.
///
/// Questa funzione configura i provider necessari per l'applicazione, creandoli con le loro dipendenze.
/// I provider sono responsabili dell'accesso ai dati e della loro fornitura ai livelli superiori dell'applicazione.
/// Utilizza l'approccio "lazy" per creare i provider solo quando vengono effettivamente richiesti.
///
/// Parameters:
/// - `databaseHelper`: L'istanza di `DatabaseHelper` necessaria per creare i provider.
///
/// Returns:
/// - Una lista di `SingleChildWidget` contenente i provider configurati.
List<SingleChildWidget> getProviders(DatabaseHelper databaseHelper) {
  return [
    // Fornisce il `WorkEntriesProvider` all'albero dei widget, creandolo con il `DatabaseHelper`.
    // Il `WorkEntriesProvider` è responsabile dell'accesso ai dati delle voci di lavoro tramite il database.
    // Utilizza l'approccio "lazy" per creare il provider solo quando viene effettivamente richiesto.
    Provider<WorkEntryProvider>(
      create: (_) => WorkEntryProvider(databaseHelper),
      lazy: true,
    ),
  ];
}