import 'package:flutter/material.dart';
import 'package:timetrailblazer/app_initializer.dart';

/// Il punto di ingresso dell'applicazione TimeTrailBlazer.
///
/// Questa funzione `main` esegue le seguenti operazioni:
/// 1. Chiama il metodo `initialize` della classe `AppInitializer` per inizializzare l'app.
/// 2. Avvia l'applicazione Flutter con il widget root restituito da `AppInitializer.initialize()`.
void main() async {
  final app = await AppInitializer.initialize();
  runApp(app);
}