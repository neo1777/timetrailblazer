import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onEndDateChanged;
  final VoidCallback onCurrentMonthPressed;

  const DateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onCurrentMonthPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () => _selectDate(context, true),
            child: Text('Dal: ${DateFormat('dd/MM/yyyy').format(startDate)}'),
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
