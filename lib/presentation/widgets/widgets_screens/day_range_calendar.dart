import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_event.dart';
import 'package:timetrailblazer/presentation/screens/edit_work_entry_screen.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';

/// Il widget `DayRangeCalendar` visualizza le voci di lavoro in un calendario variabile.
///
/// Questo widget accetta una lista di oggetti `DayWorkEntries` che rappresentano i giorni
/// e le relative voci di lavoro. Ogni giorno viene visualizzato in una scheda (card)
/// scorrevole, mostrando la data e le voci di lavoro corrispondenti.
class DayRangeCalendar extends StatelessWidget {
  /// La lista di oggetti `DayWorkEntries` che rappresentano i giorni e le voci di lavoro.
  final List<DayWorkEntriesModel> dayWorkEntriesList;

  /// Il controller di scorrimento per il calendario.
  final ScrollController scrollController;

  final DateTime startDate;
  final DateTime endDate;

  /// Costruisce un'istanza di `DayRangeCalendar`.
  ///
  /// Richiede la lista di oggetti `DayWorkEntries` [dayWorkEntriesList] e il controller
  /// di scorrimento [scrollController].
  const DayRangeCalendar({
    super.key,
    required this.dayWorkEntriesList,
    required this.scrollController,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      itemCount: dayWorkEntriesList.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 1.5,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
      ),
      itemBuilder: (context, index) {
        final dayWorkEntries = dayWorkEntriesList[index];
        final day = dayWorkEntries.day;
        final workEntries = dayWorkEntries.workEntries;

        return _buildDayCard(context, day, workEntries);
      },
    );
  }

  /// Costruisce una scheda (card) per un giorno specifico nel calendario.
  ///
  /// La scheda mostra la data formattata del giorno e un elenco delle voci di lavoro
  /// corrispondenti a quel giorno. Ogni voce di lavoro è rappresentata da una riga
  /// con l'orario di entrata/uscita e un indicatore colorato.
  Widget _buildDayCard(
      BuildContext context, DateTime day, List<WorkEntryModel>? workEntries) {
    final formattedDate = DateFormat('EEE, dd MMM yyyy', 'it_IT').format(day);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostra la data formattata del giorno
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomAutoSizeText(
              formattedDate,
              Theme.of(context).textTheme.titleMedium!,
              TextAlign.start,
            ),
          ),
          // Mostra le voci di lavoro per il giorno corrente, se presenti
          if (workEntries != null)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: workEntries.length,
                itemBuilder: (context, index) {
                  final entry = workEntries[index];
                  final entryColor =
                      entry.isEntry! ? Colors.indigo : Colors.deepPurple;
                  final entryText = entry.isEntry! ? 'Entrata' : 'Uscita';

                  return SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomAutoSizeText(
                              '$entryText: ${DateFormat('HH:mm').format(entry.timestamp)}',
                              TextStyle(
                                color: entryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              TextAlign.start,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditWorkEntryScreen(
                                          entryId: entry.id!,
                                          startDate: startDate,
                                          endDate: endDate,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    final dateRangeModel =
                                        Provider.of<DateRangeModel>(context,
                                            listen: false);
                                    context.read<WorkEntriesBloc>().add(
                                          DeleteWorkEntry(
                                            id: entry.id!,
                                            startDate: dateRangeModel.startDate,
                                            endDate: dateRangeModel.endDate,
                                            onErrorCallback: (_, __) {},
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            // Mostra un messaggio se non ci sono voci di lavoro per il giorno corrente
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomAutoSizeText(
                  'Nessuna registrazione',
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
