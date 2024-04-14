import 'package:flutter/material.dart';

/// Classe che fornisce una chiave di navigazione globale per accedere al contesto corrente.
class NavigatorKey {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Restituisce il contesto corrente dell'applicazione.
  static BuildContext? get currentContext => navigatorKey.currentContext;
}
