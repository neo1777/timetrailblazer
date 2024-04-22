import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';
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
    return const EditWorkEntryView();
  }
}

/// Vista della schermata di modifica di una voce di lavoro.
class EditWorkEntryView extends StatelessWidget {
  /// Costruttore della vista della schermata di modifica di una voce di lavoro.
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSpacer(flex: 10),
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            const CustomSpacer(flex: 5),
            Flexible(
              flex: 30,
              child: CustomAutoSizeText(
                'Data: ${DateFormat('dd/MM/yyyy')}',
                Theme.of(context).textTheme.bodyLarge!,
                TextAlign.left,
              ),
            ),
            const CustomSpacer(flex: 2),
            const Flexible(
              flex: 10,
              child: WorkButton(
                label: AppStrings.selectDate,
                //onPressed: () => _selectDate(context),
              ),
            ),
            const CustomSpacer(flex: 30),
            Flexible(
              flex: 30,
              child: CustomAutoSizeText(
                '${AppStrings.time}: ${TimeOfDay.fromDateTime(DateTime.now()).format(context)}',
                Theme.of(context).textTheme.bodyLarge!,
                TextAlign.left,
              ),
            ),
            const CustomSpacer(flex: 2),
            const Flexible(
              flex: 10,
              child: WorkButton(
                label: AppStrings.selectTime,
                //onPressed: () => _selectTime(context),
              ),
            ),
            const CustomSpacer(flex: 200),
            const Flexible(
              flex: 10,
              child: WorkButton(
                label: AppStrings.save,
                //onPressed: () => _updateWorkEntry(context),
              ),
            ),
            const CustomSpacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
