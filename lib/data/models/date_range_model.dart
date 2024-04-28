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

  /// La data di inizio dell'intervallo di date.
  ///
  /// Rappresenta la data di inizio selezionata per l'intervallo di date di interesse.
  /// Viene utilizzata per filtrare e recuperare le voci di lavoro e le statistiche all'interno dell'intervallo specificato.
  DateTime get startDate => _startDate!;

  /// La data di fine dell'intervallo di date.
  ///
  /// Rappresenta la data di fine selezionata per l'intervallo di date di interesse.
  /// Viene utilizzata per filtrare e recuperare le voci di lavoro e le statistiche all'interno dell'intervallo specificato.
  DateTime get endDate => _endDate!;

  /// Imposta la data di inizio dell'intervallo di date.
  ///
  /// Se il valore fornito è `null`, viene impostata la data di inizio predefinita al primo giorno del mese corrente.
  /// In caso contrario, la data di inizio viene impostata al valore fornito.
  /// Dopo aver impostato la data di inizio, viene chiamato il metodo `notifyListeners()` per notificare i listener del cambiamento.
  set startDate(DateTime? value) {
    if (value == null) {
      DateTime now = DateTime.now();
      _startDate = DateTime(now.year, now.month, 1);
    } else {
      _startDate = value;
    }
    notifyListeners();
  }

  /// Imposta la data di fine dell'intervallo di date.
  ///
  /// Se il valore fornito è `null`, viene impostata la data di fine predefinita all'ultimo giorno del mese corrente.
  /// In caso contrario, la data di fine viene impostata al valore fornito.
  /// Dopo aver impostato la data di fine, viene chiamato il metodo `notifyListeners()` per notificare i listener del cambiamento.
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
