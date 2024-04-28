import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mostra la data formattata del giorno
            Flexible(
              flex: 2,
              child: CustomAutoSizeText(
                formattedDate,
                Theme.of(context).textTheme.titleSmall!,
                TextAlign.center,
              ),
            ),
            //const SizedBox(height: 8),
            // Mostra le voci di lavoro per il giorno corrente, se presenti
            if (workEntries != null)
              Flexible(
                flex: 1,
                child: ListView.builder(
                  itemCount: workEntries.length,
                  itemBuilder: (context, index) {
                    final entry = workEntries[index];
                    final entryColor =
                        entry.isEntry! ? Colors.greenAccent : Colors.redAccent;
                    final entryText = entry.isEntry! ? 'Entrata' : 'Uscita';

                    return Row(
                      children: [
                        Flexible(
                          flex: 13,
                          child: FittedBox(
                            child: CustomAutoSizeText(
                              '$entryText: ${DateFormat('HH:mm').format(entry.timestamp)}',
                              TextStyle(color: entryColor),
                              TextAlign.start,
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 25,
                        ),
                        Flexible(
                          flex: 3,
                          child: FittedBox(
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditWorkEntryScreen(
                                      entryId: entry.id!,
                                      startDate: startDate,
                                      endDate: endDate,
                                    ),
                                  ),
                                );

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         EditWorkEntryScreen(workEntry: entry),
                                //   ),
                                // ).then((updatedEntry) {
                                //   if (updatedEntry != null) {
                                //     widget.onEntryModified(updatedEntry);
                                //   }
                                // });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: FittedBox(
                            child: IconButton(
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
                                        context: context,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         // Mostra l'orario di entrata/uscita
                    //         CustomAutoSizeText(
                    //           '$entryText: ${DateFormat('HH:mm').format(entry.timestamp)}',
                    //           TextStyle(color: entryColor),
                    //           TextAlign.start,
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // );
                  },
                ),
              )
            else
              // Mostra un messaggio se non ci sono voci di lavoro per il giorno corrente
              const Flexible(
                flex: 2,
                child: CustomAutoSizeText(
                  'Nessuna registrazione',
                  TextStyle(fontWeight: FontWeight.bold),
                  TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
