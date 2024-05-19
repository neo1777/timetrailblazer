import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';

/// Il widget `DateRangePicker` consente all'utente di selezionare un intervallo di date.
class DateRangePicker extends StatelessWidget {
  /// La data di inizio dell'intervallo selezionato.
  final DateTime startDate;

  /// La data di fine dell'intervallo selezionato.
  final DateTime endDate;

  /// La funzione di callback da chiamare quando la data di inizio viene modificata.
  final Function(DateTime) onStartDateChanged;

  /// La funzione di callback da chiamare quando la data di fine viene modificata.
  final Function(DateTime) onEndDateChanged;

  /// La funzione di callback da chiamare quando viene premuto il pulsante "Mese corrente".
  final VoidCallback? onCurrentMonthPressed;

  /// Costruttore della classe `DateRangePicker`.
  ///
  /// Accetta i seguenti parametri:
  /// - `startDate`: la data di inizio dell'intervallo selezionato.
  /// - `endDate`: la data di fine dell'intervallo selezionato.
  /// - `onStartDateChanged`: la funzione di callback da chiamare quando la data di inizio viene modificata.
  /// - `onEndDateChanged`: la funzione di callback da chiamare quando la data di fine viene modificata.
  /// - `onCurrentMonthPressed`: la funzione di callback da chiamare quando viene premuto il pulsante "Mese corrente".
  const DateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.onCurrentMonthPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () => _selectDate(context, true),
            child: CustomAutoSizeText(
              'Dal: ${DateFormat('dd/MM/yyyy').format(startDate)}',
              const TextStyle(),
              TextAlign.justify,
              1,
            ),
          ),
        ),
        Flexible(
          child: ElevatedButton(
            onPressed: () => _selectDate(context, false),
            child: Text('Al: ${DateFormat('dd/MM/yyyy').format(endDate)}'),
          ),
        ),
        Flexible(
          child: ElevatedButton(
            onPressed: onCurrentMonthPressed,
            child: const Text('Mese corrente'),
          ),
        ),
      ],
    );
  }

  /// Mostra un selettore di data e chiama la funzione di callback appropriata quando una data viene selezionata.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  ///   - `isStartDate`: un flag che indica se la data selezionata è la data di inizio o di fine.
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: isStartDate ? DateTime(2000) : startDate,
      lastDate: isStartDate ? endDate : DateTime(2100),
    );

    if (pickedDate != null) {
      isStartDate
          ? onStartDateChanged(pickedDate)
          : onEndDateChanged(pickedDate);
    }
  }
}
