// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DateRangeModel extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;

  // Costruttore che inizializza startDate e endDate al mese corrente se non vengono forniti
  DateRangeModel(
    this._startDate,
    this._endDate,
  ) {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  DateTime get startDate => _startDate!;
  DateTime get endDate => _endDate!;

  // Imposta startDate assicurandoti che non sia mai nullo
  set startDate(DateTime? value) {
    if (value == null) {
      DateTime now = DateTime.now();
      _startDate = DateTime(now.year, now.month, 1);
    } else {
      _startDate = value;
    }
    notifyListeners();
  }

  // Imposta endDate assicurandoti che non sia mai nullo
  set endDate(DateTime? value) {
    if (value == null) {
      DateTime now = DateTime.now();
      _endDate = DateTime(now.year, now.month + 1, 0);
    } else {
      _endDate = value;
    }
    notifyListeners();
  }

  // Metodo per impostare startDate e endDate al mese corrente
  void setCurrentMonth() {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    notifyListeners();
  }
}
