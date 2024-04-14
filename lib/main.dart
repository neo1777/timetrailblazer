import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pine/pine.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:timetrailblazer/app.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/dependencies/bloc_providers.dart';
import 'package:timetrailblazer/dependencies/mappers.dart';
import 'package:timetrailblazer/dependencies/providers.dart';
import 'package:timetrailblazer/dependencies/repositories.dart';
import 'package:timetrailblazer/utils/logger.dart';


/// Il punto di ingresso dell'applicazione TimeTrailBlazer.
/// 
/// Inizializza il database, configura le dipendenze e avvia l'applicazione.
void main() async {
  // Assicura che i binding di Flutter siano inizializzati prima di eseguire il codice dell'app
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza la formattazione delle date per la lingua italiana
  await initializeDateFormatting('it_IT', null);

  // Verifica se l'app è in esecuzione su Windows o Linux
  if (Platform.isWindows || Platform.isLinux) {
    // Inizializza FFI (Foreign Function Interface) per Windows e Linux
    // Questo è necessario per utilizzare il database SQLite su queste piattaforme
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Crea un'istanza di DatabaseHelper per gestire il database dell'app
  final databaseHelper = DatabaseHelper();

  /// Avvia l'applicazione Flutter.
  /// 
  /// Utilizza un [FutureBuilder] per inizializzare il database e configurare le dipendenze.
  /// In caso di errore durante l'inizializzazione del database, mostra un messaggio di errore.
  /// Altrimenti, avvia l'applicazione con le dipendenze configurate.
  runApp(
    FutureBuilder(
      future: databaseHelper.initializeDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Registra l'errore utilizzando logger
            logger.e('Errore durante l\'inizializzazione del database',
                error: snapshot.error);
            // Mostra un messaggio di errore in caso di errore durante l'inizializzazione del database
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Errore durante l\'inizializzazione del database: ${snapshot.error}. Si prega di verificare che il dispositivo abbia spazio sufficiente e che l\'applicazione abbia i permessi necessari per creare il database. Se il problema persiste, contattare l\'assistenza.',
                  ),
                ),
              ),
            );
          } else {
            // Avvia l'applicazione Flutter dopo l'inizializzazione del database
            return DependencyInjectorHelper(
              mappers: getMappers(),
              providers: getProviders(databaseHelper),
              repositories: getRepositories(),
              blocs: getBlocProviders(),
              child: const App(),
            );
          }
        } else {
          // Mostra un indicatore di caricamento durante l'inizializzazione del database
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    ),
  );
}
