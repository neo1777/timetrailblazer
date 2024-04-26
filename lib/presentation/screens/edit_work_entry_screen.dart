import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

/// Schermata per la modifica di una voce di lavoro.
///
/// Questa schermata consente all'utente di modificare i dettagli di una voce di lavoro esistente,
/// come la data e l'ora. Le modifiche vengono salvate quando l'utente preme il pulsante "Salva".
class EditWorkEntryScreen extends StatefulWidget {
  /// La voce di lavoro da modificare.
  final WorkEntryModel workEntry;

  /// Costruttore della schermata di modifica della voce di lavoro.
  ///
  /// Parametri:
  ///   - `workEntry`: la voce di lavoro da modificare.
  const EditWorkEntryScreen({super.key, required this.workEntry});

  @override
  State<EditWorkEntryScreen> createState() => _EditWorkEntryScreenState();
}

class _EditWorkEntryScreenState extends State<EditWorkEntryScreen> {
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
            const CustomSpacer(flex: 2),
            Flexible(
              flex: 2,
              child: _buildDateSection(context, widget.workEntry),
            ),
            const CustomSpacer(flex: 1),
            Flexible(
              flex: 2,
              child: _buildTimeSection(context, widget.workEntry),
            ),
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
      onPressed: () {
        // Temporary placeholder for save functionality
        //Navigator.pop(context);
        _updateWorkEntry(context);
      },
    );
  }

  /// Costruisce la sezione per la selezione della data.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  ///   - `workEntry`: la voce di lavoro corrente.
  Widget _buildDateSection(BuildContext context, WorkEntryModel workEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: CustomAutoSizeText(
            'Data: ${DateFormat('dd/MM/yyyy').format(workEntry.timestamp)}',
            Theme.of(context).textTheme.bodyLarge!,
            TextAlign.left,
          ),
        ),
        const CustomSpacer(flex: 1),
        Flexible(
          flex: 1,
          child: WorkButton(
            label: AppStrings.selectDate,
            onPressed: () {
              setState(() {});
              _selectDate(context);
            },
          ),
        ),
      ],
    );
  }

  /// Costruisce la sezione per la selezione dell'ora.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  ///   - `workEntry`: la voce di lavoro corrente.
  Widget _buildTimeSection(BuildContext context, WorkEntryModel workEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: CustomAutoSizeText(
            '${AppStrings.time}: ${TimeOfDay.fromDateTime(workEntry.timestamp).format(context)}',
            Theme.of(context).textTheme.bodyLarge!,
            TextAlign.left,
          ),
        ),
        const CustomSpacer(flex: 1),
        Flexible(
          flex: 1,
          child: WorkButton(
            label: AppStrings.selectTime,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }

  /// Mostra un selettore di data e aggiorna la data della voce di lavoro.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _selectDate(BuildContext context) async {
    //final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final dateRangeModel = Provider.of<DateRangeModel>(context, listen: false);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateRangeModel.startDate,
      firstDate: DateTime(2000),
      lastDate: dateRangeModel.endDate,
    );

    // Validazione dei dati
    if (picked != null) {
      if (picked.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        // Mostra un messaggio di errore se la data selezionata è precedente a ieri
        // ErrorHandler.showErrorDialog(
        //   AppErrorMessages.invalidDate,
        //   AppErrorMessages.invalidDateMessage,
        // );
        return;
      }
      //editWorkEntryBloc.add(UpdateDate(picked));
    }
  }

  /// Mostra un selettore di ora e aggiorna l'ora della voce di lavoro.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  Future<void> _selectTime(BuildContext context) async {
    //final editWorkEntryBloc = context.read<EditWorkEntryBloc>();
    final dateRangeModel = Provider.of<DateRangeModel>(context, listen: false);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateRangeModel.startDate),
    );

    // Validazione dei dati
    // if (picked != null) {
    //   final now = DateTime.now();
    //   final selectedDateTime = DateTime(
    //     editWorkEntryBloc.state.workEntry.timestamp.year,
    //     editWorkEntryBloc.state.workEntry.timestamp.month,
    //     editWorkEntryBloc.state.workEntry.timestamp.day,
    //     picked.hour,
    //     picked.minute,
    //   );

    //   if (selectedDateTime.isAfter(now)) {
    //     // Mostra un messaggio di errore se l'orario selezionato è nel futuro
    //     // ErrorHandler.showErrorDialog(
    //     //   AppErrorMessages.invalidTime,
    //     //   AppErrorMessages.invalidTimeMessage,
    //     // );
    //     return;
    //   }
    //   //editWorkEntryBloc.add(UpdateTime(picked));
    // }
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
      if (widget.workEntry.timestamp
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        throw Exception(AppErrorMessages.invalidDate);
      }
      if (widget.workEntry.timestamp.isAfter(DateTime.now())) {
        throw Exception(AppErrorMessages.invalidTime);
      }
      Navigator.pop(context, widget.workEntry);
    } catch (e) {
      // logger.e(AppErrorMessages.updateError, error: e);
      // ErrorHandler.showErrorDialog(
      //   AppErrorMessages.updateError,
      //   AppErrorMessages.updateErrorMessage(e.toString()),
      // );
    }
  }
}



/**
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
*/