import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/config/app_constants.dart';
import 'package:timetrailblazer/domain/blocs/edit_work_entry/edit_work_entry_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/error_handler.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// Schermata per la modifica di una voce di lavoro.
///
/// Questa schermata consente all'utente di modificare i dettagli di una voce di lavoro esistente,
/// come la data e l'ora. Le modifiche vengono salvate quando l'utente preme il pulsante "Salva".
///
/// Esempio di utilizzo:
///
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => EditWorkEntryScreen(workEntry: entry),
///   ),
/// );
class EditWorkEntryScreen extends StatelessWidget {
  /// La voce di lavoro da modificare.
  final WorkEntry workEntry;

  /// Costruttore della schermata di modifica della voce di lavoro.
  ///
  /// Parametri:
  ///   - `workEntry`: la voce di lavoro da modificare.
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
        title: const Text(AppStrings.editWorkEntryTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
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
                        const SizedBox(height: AppDimensions.smallSpacing),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text(AppStrings.selectDate),
                        ),
                        const SizedBox(height: AppDimensions.mediumSpacing),
                        Text(
                          '${AppStrings.time}: ${TimeOfDay.fromDateTime(workEntry.timestamp).format(context)}',
                          style: TextStyle(fontSize: fontSize),
                        ),
                        const SizedBox(height: AppDimensions.smallSpacing),
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: const Text(AppStrings.selectTime),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppDimensions.largeSpacing),
            ElevatedButton(
              onPressed: () => _updateWorkEntry(context),
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra un selettore di data e aggiorna la data della voce di lavoro.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _selectDate(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: editWorkEntryBloc.state.workEntry.timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    // Validazione dei dati
    if (picked != null) {
      if (picked.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        // Mostra un messaggio di errore se la data selezionata è precedente a ieri
        ErrorHandler.showErrorDialog(
          AppErrorMessages.invalidDate,
          AppErrorMessages.invalidDateMessage,
        );
        return;
      }
      editWorkEntryBloc.add(UpdateDate(picked));
    }
  }

  /// Mostra un selettore di ora e aggiorna l'ora della voce di lavoro.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _selectTime(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(editWorkEntryBloc.state.workEntry.timestamp),
    );

    // Validazione dei dati
    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        editWorkEntryBloc.state.workEntry.timestamp.year,
        editWorkEntryBloc.state.workEntry.timestamp.month,
        editWorkEntryBloc.state.workEntry.timestamp.day,
        picked.hour,
        picked.minute,
      );

      if (selectedDateTime.isAfter(now)) {
        // Mostra un messaggio di errore se l'orario selezionato è nel futuro
        ErrorHandler.showErrorDialog(
          AppErrorMessages.invalidTime,
          AppErrorMessages.invalidTimeMessage,
        );
        return;
      }
      editWorkEntryBloc.add(UpdateTime(picked));
    }
  }

  /// Aggiorna la voce di lavoro nel database e torna alla schermata precedente.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _updateWorkEntry(BuildContext context) async {
    final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final workEntry = editWorkEntryBloc.state.workEntry;
    try {
      // Controlla se i dati sono validi prima di chiamare il metodo del repository
      if (workEntry.timestamp
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        throw Exception(AppErrorMessages.invalidDate);
      }
      if (workEntry.timestamp.isAfter(DateTime.now())) {
        throw Exception(AppErrorMessages.invalidTime);
      }
      context.read<WorkEntriesBloc>().add(UpdateWorkEntry(workEntry));
      Navigator.pop(context, workEntry);
    } catch (e) {
      logger.e(AppErrorMessages.updateError, error: e);
      ErrorHandler.showErrorDialog(
        AppErrorMessages.updateError,
        AppErrorMessages.updateErrorMessage(e.toString()),
      );
    }
  }
}
