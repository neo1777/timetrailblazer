import 'package:logger/logger.dart';

/// Istanza del logger utilizzata per registrare i messaggi di log nell'applicazione.
///
/// Il logger è configurato con le seguenti opzioni:
/// - `methodCount`: il numero di metodi da visualizzare nella traccia dello stack.
/// - `errorMethodCount`: il numero di metodi da visualizzare nella traccia dello stack in caso di errore.
/// - `lineLength`: la lunghezza massima di ogni riga di log.
/// - `colors`: abilita i colori nella console per una migliore leggibilità.
/// - `printEmojis`: abilita l'uso di emoji nei messaggi di log.
/// - `printTime`: abilita la stampa del timestamp per ogni messaggio di log.
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
