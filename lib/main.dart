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

/// La funzione principale che viene eseguita all'avvio dell'applicazione.
/// È contrassegnata come `async` perché contiene operazioni asincrone, come l'inizializzazione del database.
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
  // Inizializza il database chiamando il metodo `initializeDatabase()` del DatabaseHelper
  try {
    await databaseHelper.initializeDatabase();

    /// Avvia l'applicazione Flutter utilizzando il widget `DependencyInjectorHelper` di Pine
    /// Il `DependencyInjectorHelper` viene utilizzato per l'iniezione delle dipendenze nell'albero dei widget
    /// Vengono forniti i mapper, i provider, i repository e i BLoC necessari all'applicazione
    runApp(
      DependencyInjectorHelper(
        mappers: getMappers(), // Ottiene i mapper per la conversione dei dati
        providers: getProviders(
            databaseHelper), // Ottiene i provider per l'accesso ai servizi e ai dati
        repositories:
            getRepositories(), // Ottiene i repository per la gestione dei dati
        blocs:
            getBlocProviders(), // Ottiene i BLoC per la gestione dello stato dell'app
        child:
            const App(), // Il widget radice dell'applicazione, definito in `app.dart`
      ),
    );
  } catch (e) {
    logger.e('Errore durante l\'inizializzazione del database', error: e);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Errore durante l\'inizializzazione del database: ${e.toString()}. Si prega di verificare che il dispositivo abbia spazio sufficiente e che l\'applicazione abbia i permessi necessari per creare il database. Se il problema persiste, contattare l\'assistenza.',
            ),
          ),
        ),
      ),
    );
  }
}
