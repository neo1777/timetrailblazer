// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/edit_work_entry/edit_work_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

/// Schermata per la modifica di una voce di lavoro.
///
/// Questa schermata consente all'utente di modificare i dettagli di una voce di lavoro esistente,
/// come la data e l'ora. Le modifiche vengono salvate quando l'utente preme il pulsante "Salva".
class EditWorkEntryScreen extends StatelessWidget {
  /// L'ID della voce di lavoro da modificare.
  final int entryId;
  final DateTime startDate;
  final DateTime endDate;

  /// Costruttore della schermata `EditWorkEntryScreen`.
  ///
  /// Accetta l'ID della voce di lavoro da modificare come parametro obbligatorio.
  const EditWorkEntryScreen({
    super.key,
    required this.entryId,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    /// Restituisce un widget `BlocProvider` che fornisce il BLoC `EditWorkBloc` alla sottoalbero di widget.
    ///
    /// Il BLoC viene creato con lo stato iniziale `EditWorkInitial` e il repository delle voci di lavoro
    /// ottenuto dal contesto tramite `context.read()`.
    ///
    /// Quando il BLoC viene creato, viene emesso l'evento `LoadWorkEntry` per caricare la voce di lavoro
    /// corrispondente all'ID fornito.
    ///
    /// Il figlio del `BlocProvider` è la vista effettiva della schermata, rappresentata da `EditWorkEntryView`.
    return BlocProvider(
      create: (context) => EditWorkBloc(
        EditWorkInitial(),
        workEntryRepository: context.read(),
      )..add(LoadWorkEntry(entryId: entryId)),
      child: EditWorkEntryView(
        entryId: entryId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }
}

/// Vista della schermata di modifica di una voce di lavoro.
///
/// Questa vista visualizza i widget per la modifica dei dettagli della voce di lavoro,
/// come la data e l'ora, e il pulsante di salvataggio.
///
/// La vista reagisce agli stati emessi dal BLoC `EditWorkBloc` e aggiorna l'interfaccia utente
/// di conseguenza.
class EditWorkEntryView extends StatelessWidget {
  final int entryId;
  final DateTime startDate;
  final DateTime endDate;

  /// Costruttore della vista `EditWorkEntryView`.
  const EditWorkEntryView({
    super.key,
    required this.entryId,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    /// Restituisce un widget `Scaffold` che rappresenta la struttura di base della schermata.
    ///
    /// La barra delle applicazioni viene creata utilizzando il widget `CustomAppBar` e visualizza
    /// il titolo della schermata e un pulsante per tornare indietro.
    ///
    /// Il corpo della schermata è un widget `BlocBuilder` che ricostruisce l'interfaccia utente
    /// in base agli stati emessi dal BLoC `EditWorkBloc`.
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.editWorkEntryTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<EditWorkBloc, EditWorkState>(
        builder: (context, state) {
          /// Se lo stato è `EditWorkLoading`, viene visualizzato un indicatore di caricamento.
          if (state is EditWorkLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Se lo stato è `EditWorkDataChanged`, vengono visualizzati i widget per la modifica
          /// dei dettagli della voce di lavoro e il pulsante di salvataggio.
          else if (state is EditWorkDataChanged) {
            final workEntry = state.workEntry;
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomSpacer(flex: 1),
                  Flexible(
                      flex: 2,
                      child: _buildDateButton(context, workEntry.timestamp)),
                  const CustomSpacer(flex: 1),
                  Flexible(
                      flex: 2,
                      child: _buildTimeButton(context, workEntry.timestamp)),
                  const CustomSpacer(flex: 10),
                  Flexible(
                      flex: 2,
                      child: _buildSaveButton(
                          context, state.isSaveEnabled, workEntry)),
                  const CustomSpacer(flex: 1),
                ],
              ),
            );
          }

          /// Se lo stato è `EditWorkError`, viene visualizzato un messaggio di errore.
          else if (state is EditWorkError) {
            return Center(child: Text(state.message));
          }

          /// Se lo stato non corrisponde a nessuno dei casi precedenti, viene restituito un
          /// contenitore vuoto.
          else {
            return Container();
          }
        },
      ),
    );
  }

  /// Costruisce il pulsante per la selezione della data.
  ///
  /// Accetta il contesto e la data attualmente selezionata come parametri.
  ///
  /// Restituisce un widget WorkButton che visualizza la data attualmente selezionata
  /// e permette all'utente di selezionare una nuova data quando viene premuto.
  ///
  /// Quando il pulsante viene premuto, viene mostrato un selettore di data (showDatePicker)
  /// che consente all'utente di selezionare una nuova data.
  ///
  /// Se l'utente seleziona una nuova data, viene emesso l'evento DateChanged al BLoC EditWorkBloc
  /// con la nuova data selezionata.
  Widget _buildDateButton(BuildContext context, DateTime selectedDate) {
    final editWorkBloc = context.read<EditWorkBloc>();
    return WorkButton(
      label: 'Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          editWorkBloc.add(DateChanged(newDate: pickedDate));
        }
      },
    );
  }

  /// Costruisce il pulsante per la selezione dell'ora.
  ///
  /// Accetta il contesto e l'ora attualmente selezionata come parametri.
  ///
  /// Restituisce un widget WorkButton che visualizza l'ora attualmente selezionata
  /// e permette all'utente di selezionare una nuova ora quando viene premuto.
  ///
  /// Quando il pulsante viene premuto, viene mostrato un selettore di ora (showTimePicker)
  /// che consente all'utente di selezionare una nuova ora.
  ///
  /// Se l'utente seleziona una nuova ora, viene emesso l'evento TimeChanged al BLoC EditWorkBloc
  /// con la nuova ora selezionata.
  Widget _buildTimeButton(BuildContext context, DateTime selectedTime) {
    final editWorkBloc = context.read<EditWorkBloc>();

    return WorkButton(
      label: 'Ora: ${DateFormat('HH:mm').format(selectedTime)}',
      onPressed: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedTime),
        );

        if (pickedTime != null) {
          editWorkBloc.add(TimeChanged(
              newTime: DateTime(
            selectedTime.year,
            selectedTime.month,
            selectedTime.day,
            pickedTime.hour,
            pickedTime.minute,
          )));
        }
      },
    );
  }

  /// Costruisce il pulsante di salvataggio.
  ///
  /// Accetta il contesto, un flag che indica se il salvataggio è abilitato e la voce di lavoro
  /// da salvare come parametri.
  ///
  /// Restituisce un widget WorkButton che visualizza l'etichetta "Salva" e permette all'utente
  /// di salvare le modifiche alla voce di lavoro quando viene premuto.
  ///
  /// Il pulsante è abilitato solo se il flag isSaveEnabled è true.
  ///
  /// Quando il pulsante viene premuto, viene emesso l'evento SaveWorkEntry al BLoC EditWorkBloc
  /// con la voce di lavoro da salvare e la schermata viene chiusa.
  Widget _buildSaveButton(
      BuildContext context, bool isSaveEnabled, WorkEntryModel workEntry) {
    final editWorkBloc = context.read<EditWorkBloc>();
    final workEntriesBloc = context.read<WorkEntriesBloc>();

    return WorkButton(
      label: AppStrings.save,
      onPressed: isSaveEnabled
          ? () {
              editWorkBloc.add(SaveWorkEntry(workEntry: workEntry));

              // Emetti l'evento FetchWorkEntries con le date di inizio e di fine passate
              workEntriesBloc.add(FetchWorkEntries(
                startDate,
                endDate,
              ));

              Navigator.pop(context);
            }
          : null,
    );
  }
}
