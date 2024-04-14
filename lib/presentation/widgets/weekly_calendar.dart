import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/config/app_constants.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/presentation/screens/edit_work_entry_screen.dart';

/// Il widget `WeeklyCalendar` visualizza le voci di lavoro in un calendario.
class WeeklyCalendar extends StatefulWidget {
  final Map<DateTime, List<WorkEntry>> entriesGroupedByDay;
  final Function(WorkEntry, int, DateTime) onEntryDeleted;
  final Function(WorkEntry) onEntryModified;
  final ScrollController scrollController;
  final DateTime startDate;
  final DateTime endDate;

  const WeeklyCalendar({
    super.key,
    required this.entriesGroupedByDay,
    required this.onEntryDeleted,
    required this.onEntryModified,
    required this.scrollController,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  @override
  Widget build(BuildContext context) {
    final startDate = widget.startDate;
    final endDate = widget.endDate;
    final daysCount = endDate.difference(startDate).inDays + 1;

    // Utilizza `ListView.builder` per generare le righe del calendario
    // Ogni riga rappresenta un giorno nel range di date specificato
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: daysCount,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final day = DateTime(
          startDate.year,
          startDate.month,
          startDate.day + index,
        );
        final entriesForDay = widget.entriesGroupedByDay[day] ?? [];
        return _buildDayRow(context, day, entriesForDay);
      },
    );
  }

  /// Costruisce una riga per un giorno nel calendario.
  /// 
  /// Parametri:
  ///   - `context`: il contesto del widget.
  ///   - `day`: la data del giorno.
  ///   - `entries`: le voci di lavoro per il giorno specificato.
  Widget _buildDayRow(
      BuildContext context, DateTime day, List<WorkEntry> entries) {
    final formattedDate = DateFormat('EEE, dd MMM yyyy', 'it_IT').format(day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...entries.map((entry) {
          final entryColor = entry.isEntry ? AppColors.entryColor : AppColors.exitColor;

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  // Swipe da destra a sinistra per eliminare la voce di lavoro
                  widget.onEntryDeleted(entry, entry.id!, entry.day);
                } else if (details.primaryVelocity! > 0) {
                  // Swipe da sinistra a destra per modificare la voce di lavoro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditWorkEntryScreen(workEntry: entry),
                    ),
                  ).then((updatedEntry) {
                    if (updatedEntry != null) {
                      widget.onEntryModified(updatedEntry);
                    }
                  });
                }
              }
            },
            child: ListTile(
              title: Text(
                '${entry.isEntry ? 'Entrata' : 'Uscita'}: ${DateFormat('HH:mm').format(entry.timestamp)}',
                style: TextStyle(color: entryColor),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditWorkEntryScreen(workEntry: entry),
                        ),
                      ).then((updatedEntry) {
                        if (updatedEntry != null) {
                          widget.onEntryModified(updatedEntry);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onEntryDeleted(entry, entry.id!, entry.day);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
