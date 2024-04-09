import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Il widget `WorkStatsListItem` rappresenta un elemento della lista delle statistiche di lavoro.
class WorkStatsListItem extends StatelessWidget {
  final String date;
  final Duration duration;

  const WorkStatsListItem({
    super.key,
    required this.date,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.work),
      title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(date))),
      subtitle: Text(
        'Tempo di lavoro: ${duration.inHours} ore ${duration.inMinutes.remainder(60)} minuti',
      ),
    );
  }
}