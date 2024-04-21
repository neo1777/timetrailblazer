import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pine/pine.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timetrailblazer/app.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/di/bloc_providers.dart';
import 'package:timetrailblazer/di/mappers.dart';
import 'package:timetrailblazer/di/providers.dart';
import 'package:timetrailblazer/di/repositories.dart';

/// La classe `AppInitializer` contiene la logica di inizializzazione dell'app.
///
/// Questa classe si occupa di inizializzare il database, configurare le dipendenze
/// e restituire il widget root dell'applicazione.
class AppInitializer {
  /// Inizializza l'applicazione.
  ///
  /// Questo metodo esegue le seguenti operazioni:
  /// 1. Assicura che i binding di Flutter siano inizializzati.
  /// 2. Inizializza la formattazione delle date per la lingua italiana.
  /// 3. Verifica se l'app è in esecuzione su Windows o Linux e inizializza FFI se necessario.
  /// 4. Crea un'istanza di `DatabaseHelper` per gestire il database dell'app.
  /// 5. Utilizza un `FutureBuilder` per inizializzare il database e configurare le dipendenze.
  /// 6. In caso di errore durante l'inizializzazione del database, mostra un messaggio di errore.
  /// 7. Altrimenti, restituisce il widget root dell'app con le dipendenze configurate.
  static Future<Widget> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('it_IT', null);

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databaseHelper = DatabaseHelper();

    return FutureBuilder(
      future:  databaseHelper.database,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
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
            return DependencyInjectorHelper(
               mappers: getMappers(),
               providers: getProviders(databaseHelper),
               repositories: getRepositories(),
               blocs: getBlocProviders(),
              child: const App(),
            );
          }
      },
    );
  }
}
