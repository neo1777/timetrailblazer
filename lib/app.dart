import 'package:flutter/material.dart';
import 'package:timetrailblazer/presentation/screens/home_page.dart';
import 'package:timetrailblazer/presentation/screens/work_entries_screen.dart';
import 'package:timetrailblazer/presentation/screens/work_stats_screen.dart';

/// La classe principale dell'applicazione che rappresenta il punto di ingresso dell'app.
/// Estende la classe `StatelessWidget` di Flutter, che indica che questo widget non ha uno stato mutabile.
class App extends StatelessWidget {
  /// Il costruttore della classe `App`.
  /// Accetta una chiave opzionale `key` che viene passata al costruttore della superclasse `StatelessWidget`.
  const App({super.key});

  /// Il metodo `build` è un override del metodo della superclasse `StatelessWidget`.
  /// Viene chiamato quando il widget deve essere renderizzato.
  /// Accetta un parametro `context` che rappresenta la posizione del widget nell'albero dei widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'timetrailblazer', // Il titolo dell'applicazione, utilizzato per scopi di accessibilità e indicizzazione
      theme: ThemeData(
        primarySwatch: Colors.blue, // Il colore primario del tema dell'app, utilizzato per elementi come la AppBar
      ),
      initialRoute: '/', // La rotta iniziale dell'applicazione, in questo caso la HomePage
      routes: {
        // Un oggetto `Map` che definisce le rotte dell'applicazione e i corrispondenti widget da visualizzare
        '/': (context) => const HomePage(), // La rotta per la HomePage, che viene visualizzata quando l'app viene avviata
        '/work_entries': (context) => const WorkEntriesScreen(), // La rotta per la WorkEntriesScreen, che mostra le voci di lavoro registrate
        '/work_stats': (context) => const WorkStatsScreen(), // La rotta per la WorkStatsScreen, che mostra le statistiche di lavoro
      },
    );
  }
}