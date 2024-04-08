import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/domain/blocs/edit_work_entry/edit_work_entry_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/error_handler.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// Schermata per la modifica di una voce di lavoro.
class EditWorkEntryScreen extends StatelessWidget {
  final WorkEntry workEntry;

  const EditWorkEntryScreen({super.key, required this.workEntry});

  @override
  Widget build(BuildContext context) {
    // Il `BlocProvider` viene utilizzato per fornire il `EditWorkEntryBloc` alla schermata
    // Viene passata la voce di lavoro iniziale al costruttore del bloc
    return BlocProvider(
      create: (context) => EditWorkEntryBloc(workEntry),
      child: const EditWorkEntryView(),
    );
  }
}

/// Vista della schermata di modifica di una voce di lavoro.
class EditWorkEntryView extends StatelessWidget {
  const EditWorkEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica registrazione'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mostra la data e l'ora attuali della voce di lavoro e consente di modificarle.
            BlocBuilder<EditWorkEntryBloc, EditWorkEntryState>(
              builder: (context, state) {
                final workEntry = state.workEntry;
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double fontSize =
                        constraints.maxWidth < 600 ? 16 : 18;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data: ${DateFormat('dd/MM/yyyy').format(workEntry.timestamp)}',
                          style: TextStyle(fontSize: fontSize),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Seleziona data'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ora: ${TimeOfDay.fromDateTime(workEntry.timestamp).format(context)}',
                          style: TextStyle(fontSize: fontSize),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: const Text('Seleziona ora'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _updateWorkEntry(context),
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra un selettore di data e aggiorna la data della voce di lavoro.
  Future<void> _selectDate(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: editWorkEntryBloc.state.workEntry.timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      editWorkEntryBloc.add(UpdateDate(picked));
    }
  }

  /// Mostra un selettore di ora e aggiorna l'ora della voce di lavoro.
  Future<void> _selectTime(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(editWorkEntryBloc.state.workEntry.timestamp),
    );
    if (picked != null) {
      editWorkEntryBloc.add(UpdateTime(picked));
    }
  }

  /// Aggiorna la voce di lavoro nel database e torna alla schermata precedente.
  Future<void> _updateWorkEntry(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final workEntry = editWorkEntryBloc.state.workEntry;
    try {
      context.read<WorkEntriesBloc>().add(UpdateWorkEntry(workEntry));
      Navigator.pop(context, workEntry);
    } catch (e) {
      logger.e('Errore durante l\'aggiornamento della voce di lavoro', error: e);
      ErrorHandler.showErrorDialog(context, 'Errore di aggiornamento', 'Errore durante l\'aggiornamento della voce di lavoro: ${e.toString()}. Si prega di verificare i dati inseriti e riprovare. Se il problema persiste, contattare l\'assistenza.');
    }
  }

}
