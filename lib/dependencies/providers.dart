import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/dependencies/providers/work_entries_provider.dart';

/// Restituisce una lista di `SingleChildWidget` per l'iniezione dei provider nell'albero dei widget.
List<SingleChildWidget> getProviders(DatabaseHelper databaseHelper) {
  return [
    // Fornisce il `WorkEntriesProvider` all'albero dei widget, creandolo con il `DatabaseHelper`.
    // Il `WorkEntriesProvider` è responsabile dell'accesso ai dati delle voci di lavoro tramite il database.
    Provider<WorkEntriesProvider>(
      create: (_) => WorkEntriesProvider(databaseHelper),
    ),
  ];
}
