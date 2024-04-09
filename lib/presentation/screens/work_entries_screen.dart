import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetrailblazer/constants.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/weekly_calendar.dart';
import 'package:timetrailblazer/utils/error_handler.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La schermata che mostra le voci di lavoro registrate.
class WorkEntriesScreen extends StatefulWidget {
  const WorkEntriesScreen({super.key});

  @override
  WorkEntriesScreenState createState() => WorkEntriesScreenState();
}

/// Lo stato della schermata delle voci di lavoro.
class WorkEntriesScreenState extends State<WorkEntriesScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  late WorkEntriesBloc _workEntriesBloc;

  @override
  void initState() {
    super.initState();
    _workEntriesBloc = context.read<WorkEntriesBloc>();
    _loadSelectedDates();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Recupera le voci di lavoro dal database.
  void _fetchWorkEntries() {
    _workEntriesBloc.add(
      FetchWorkEntries(
        startDate: _startDate,
        endDate: _endDate.add(const Duration(days: 1)),
      ),
    );
  }

  /// Esporta le voci di lavoro in un file CSV.
  Future<void> _exportToCsv() async {
    final state = _workEntriesBloc.state;
    if (state is WorkEntriesLoaded) {
      final entries = state.entries;
      try {
        final path =
            await context.read<WorkEntriesRepository>().exportToCsv(entries);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$csvExportSuccess $path')),
          );
        }
      } catch (e) {
        logger.e(
            'Errore durante l\'esportazione delle voci di lavoro in formato CSV',
            error: e);
        ErrorHandler.showErrorDialog('Errore di esportazione',
            'Errore durante l\'esportazione delle voci di lavoro in formato CSV: ${e.toString()}. Si prega di verificare che ci sia spazio sufficiente sul dispositivo e che l\'applicazione abbia i permessi necessari per scrivere i file.');
      }
    }
  }

  /// Reimposta il database eliminando tutte le voci di lavoro.
  Future<void> _resetDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(confirmResetTitle),
        content: const Text(confirmResetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(confirmButtonText),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _workEntriesBloc.add(DeleteAllWorkEntries(_startDate, _endDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(workEntriesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importFromCsv,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToCsv,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _resetDatabase,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
              builder: (context, state) {
                /// Ottiene le date di inizio e fine dallo stato `WorkEntriesDateRangeUpdated` se presente,
                /// altrimenti utilizza le variabili di stato `_startDate` e `_endDate`.
                final DateTime startDate = state is WorkEntriesDateRangeUpdated
                    ? state.startDate
                    : _startDate;
                final DateTime endDate = state is WorkEntriesDateRangeUpdated
                    ? state.endDate
                    : _endDate;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        child: FittedBox(
                          child: Text(
                            'Dal: ${DateFormat('dd/MM/yyyy').format(startDate)}',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        child: FittedBox(
                          child: Text(
                            'Al: ${DateFormat('dd/MM/yyyy').format(endDate)}',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: _resetToCurrentMonth,
                        child: const FittedBox(
                          child: Text('Mese corrente'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/work_stats');
                        },
                        child: const FittedBox(
                          child: Text('Statistiche di lavoro'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
              builder: (context, state) {
                if (state is WorkEntriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WorkEntriesError) {
                  ErrorHandler.showErrorNotification(
                      'Errore durante il caricamento delle voci di lavoro: ${state.message}. Si prega di riprovare più tardi o verificare la connessione di rete.');
                  return Container();
                }
                if (state is WorkEntriesLoaded) {
                  // Il `WeeklyCalendar` viene utilizzato per visualizzare le voci di lavoro raggruppate per giorno
                  return WeeklyCalendar(
                    entriesGroupedByDay: state.entriesGroupedByDay,
                    onEntryDeleted: (entryId, day) {
                      _workEntriesBloc.add(DeleteWorkEntry(entryId, day));
                    },
                    onEntryModified: (entry) {
                      _workEntriesBloc.add(UpdateWorkEntry(entry));
                    },
                    scrollController: _scrollController,
                    startDate: _startDate,
                    endDate: _endDate,
                  );
                }
                return WeeklyCalendar(
                  entriesGroupedByDay: const {},
                  onEntryDeleted: (_, __) {},
                  onEntryModified: (_) {},
                  scrollController: _scrollController,
                  startDate: _startDate,
                  endDate: _endDate,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra un selettore di data per scegliere la data di inizio o di fine delle voci di lavoro.
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final firstDate = isStartDate ? DateTime(2000, 1, 1) : _startDate;
    final lastDate = isStartDate ? _endDate : DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Validazione dei dati
    if (pickedDate != null) {
      if (isStartDate && pickedDate.isAfter(_endDate)) {
        // Mostra un messaggio di errore se la data di inizio selezionata è successiva alla data di fine
        ErrorHandler.showErrorDialog(
          'Data non valida',
          'La data di inizio non può essere successiva alla data di fine. Per favore, seleziona una data di inizio valida.',
        );
        return;
      }
      if (!isStartDate && pickedDate.isBefore(_startDate)) {
        // Mostra un messaggio di errore se la data di fine selezionata è precedente alla data di inizio
        ErrorHandler.showErrorDialog(
          'Data non valida',
          'La data di fine non può essere precedente alla data di inizio. Per favore, seleziona una data di fine valida.',
        );
        return;
      }
      if (isStartDate) {
        _startDate = pickedDate;
      } else {
        _endDate = pickedDate;
      }
      _addUpdateDateRangeEvent();
    }
  }

  /// Aggiunge un evento `UpdateDateRange` al BLoC, recupera le voci di lavoro e salva le date selezionate.
  void _addUpdateDateRangeEvent() {
    _workEntriesBloc.add(UpdateDateRange(_startDate, _endDate));
    _fetchWorkEntries();
    _saveSelectedDates();
  }

  /// Carica le date selezionate da `shared_preferences` e le passa al BLoC.
  Future<void> _loadSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final startDateMillis = prefs.getInt('startDate');
    final endDateMillis = prefs.getInt('endDate');

    if (startDateMillis != null && endDateMillis != null) {
      _startDate = DateTime.fromMillisecondsSinceEpoch(startDateMillis);
      _endDate = DateTime.fromMillisecondsSinceEpoch(endDateMillis);
      _workEntriesBloc.add(UpdateDateRange(_startDate, _endDate));
    }

    _fetchWorkEntries();
  }

  /// Salva le date selezionate in `shared_preferences`.
  Future<void> _saveSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startDate', _startDate.millisecondsSinceEpoch);
    await prefs.setInt('endDate', _endDate.millisecondsSinceEpoch);
  }

  /// Ripristina le date al mese corrente e aggiorna il BLoC.
  void _resetToCurrentMonth() {
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    _addUpdateDateRangeEvent();
  }

  /// Importa le voci di lavoro da un file CSV.
  Future<void> _importFromCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    // Validazione dei dati
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        try {
          // Controlla se il file CSV esiste e ha un formato valido prima di chiamare il metodo del repository
          final file = File(path);
          if (!await file.exists()) {
            throw Exception('File CSV non trovato');
          }
          final csvString = await file.readAsString();
          if (csvString.isEmpty) {
            throw Exception('File CSV vuoto');
          }
          if (mounted) {
            await context.read<WorkEntriesRepository>().importFromCsv(path);
          }
          _workEntriesBloc.add(FetchWorkEntries(
            startDate: _startDate,
            endDate: _endDate.add(const Duration(days: 1)),
          ));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Importazione CSV completata')),
            );
          }
        } catch (e) {
          logger.e('Errore durante l\'importazione CSV', error: e);

          ErrorHandler.showErrorSnackBar(
            'Errore durante l\'importazione CSV: ${e.toString()}',
          );
        }
      } else {
        // Mostra un messaggio di errore se il percorso del file è nullo
        ErrorHandler.showErrorSnackBar(
          'Errore durante la selezione del file CSV. Per favore, riprova e seleziona un file CSV valido.',
        );
      }
    } else {
      // Mostra un messaggio di errore se nessun file è stato selezionato
      ErrorHandler.showErrorSnackBar(
        'Nessun file CSV selezionato. Per favore, seleziona un file CSV per l\'importazione.',
      );
    }
  }
}
