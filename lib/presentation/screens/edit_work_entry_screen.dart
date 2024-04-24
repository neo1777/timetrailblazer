import 'package:flutter/material.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

/// Schermata per la modifica di una voce di lavoro.
///
/// Questa schermata consente all'utente di modificare i dettagli di una voce di lavoro esistente,
/// come la data e l'ora. Le modifiche vengono salvate quando l'utente preme il pulsante "Salva".
class EditWorkEntryScreen extends StatelessWidget {
  /// La voce di lavoro da modificare.
  final WorkEntryModel workEntry;

  /// Costruttore della schermata di modifica della voce di lavoro.
  ///
  /// Parametri:
  ///   - `workEntry`: la voce di lavoro da modificare.
  const EditWorkEntryScreen({super.key, required this.workEntry});

  @override
  Widget build(BuildContext context) {
    // Il `BlocProvider` viene utilizzato per fornire il `EditWorkEntryBloc` alla schermata
    // Viene passata la voce di lavoro iniziale al costruttore del bloc
    return const EditWorkEntryView();
  }
}

/// Vista della schermata di modifica di una voce di lavoro.
class EditWorkEntryView extends StatelessWidget {
  const EditWorkEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.editWorkEntryTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const CustomSpacer(flex: 2),
            // Flexible(
            //   flex: 2,
            //   child: _buildDateSection(context, workEntry),
            // ),
            // const CustomSpacer(flex: 1),
            // Flexible(
            //   flex: 2,
            //   child: _buildTimeSection(context, workEntry),
            // ),
            const CustomSpacer(flex: 1),
            Flexible(
              flex: 1,
              child: _buildSaveButton(context),
            ),
            const CustomSpacer(flex: 2),
          ],
        ),
      ),
    );
  }



  /// Costruisce il pulsante per il salvataggio della voce di lavoro.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Widget _buildSaveButton(BuildContext context) {
    return WorkButton(
      label: AppStrings.save,
      onPressed: () => _updateWorkEntry(context),
    );
  }



  /// Aggiorna la voce di lavoro nel database e torna alla schermata precedente.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _updateWorkEntry(BuildContext context) async {
    // final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    // final workEntry = editWorkEntryBloc.state.workEntry;
    try {
      // Controlla se i dati sono validi prima di chiamare il metodo del repository
      // if (workEntry.timestamp
      //     .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      //   throw Exception(AppErrorMessages.invalidDate);
      // }
      // if (workEntry.timestamp.isAfter(DateTime.now())) {
      //   throw Exception(AppErrorMessages.invalidTime);
      // }
      // context.read<WorkEntriesBloc>().add(UpdateWorkEntry(workEntry));
      Navigator.pop(context);
    } catch (e) {
      // logger.e(AppErrorMessages.updateError, error: e);
      // ErrorHandler.showErrorDialog(
      //   AppErrorMessages.updateError,
      //   AppErrorMessages.updateErrorMessage(e.toString()),
      // );
    }
  }
}
