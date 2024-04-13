import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetrailblazer/constants.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/date_range_picker.dart';
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
  late WorkEntriesRepositoryImpl _workEntriesRepository;
  late WorkEntriesBloc _workEntriesBloc;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _workEntriesBloc = context.read<WorkEntriesBloc>();
    _homeBloc = context.read<HomeBloc>();
    _workEntriesRepository = context.read<WorkEntriesRepositoryImpl>();
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
      _homeBloc.add(ExitButtonPressed());
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
            onPressed: _handleExportToCsv,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _resetDatabase,
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 3,
            child: DateRangePicker(
              startDate: _startDate,
              endDate: _endDate,
              onStartDateChanged: (date) {
                setState(() => _startDate = date);
                _addUpdateDateRangeEvent();
              },
              onEndDateChanged: (date) {
                setState(() => _endDate = date);
                _addUpdateDateRangeEvent();
              },
              onCurrentMonthPressed: _resetToCurrentMonth,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/work_stats');
              },
              child: const Text('Statistiche di lavoro'),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 20,
            child: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
              builder: (context, state) {
                if (state is WorkEntriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WorkEntriesError) {
                  ErrorHandler.showErrorNotification(
                    'Errore durante il caricamento delle voci di lavoro: ${state.message}. Si prega di riprovare più tardi o verificare la connessione di rete.',
                  );
                  return Container();
                }
                if (state is WorkEntriesLoaded) {
                  return WeeklyCalendar(
                    entriesGroupedByDay: state.entriesGroupedByDay,
                    onEntryDeleted: (entry, entryId, day) {
                      _workEntriesBloc.add(DeleteWorkEntry(entryId, day));
                      if (entry.isEntry) {
                        _homeBloc.add(ExitButtonPressed());
                      } else {
                        _homeBloc.add(EntryButtonPressed());
                      }
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
                  onEntryDeleted: (_, __, ___) {},
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

  /// Esporta le voci di lavoro in un file CSV.
  Future<void> _handleExportToCsv() async {
    final state = _workEntriesBloc.state;
    if (state is WorkEntriesLoaded) {
      final entries = state.entries;
      try {
        final path = await context
            .read<WorkEntriesRepositoryImpl>()
            .exportToCsv(entries);
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

          await _workEntriesRepository.importFromCsv(path);
          bool result =
              (await _workEntriesRepository.getLastWorkEntry())!.isEntry;
          if (!result) {
            _homeBloc.add(ExitButtonPressed());
          } else {
            _homeBloc.add(EntryButtonPressed());
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
