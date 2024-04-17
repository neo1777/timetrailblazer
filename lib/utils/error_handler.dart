import 'package:flutter/material.dart';
import 'package:timetrailblazer/utils/navigator_key.dart';

/// Classe che fornisce metodi statici per la gestione e la visualizzazione degli errori nell'applicazione.
class ErrorHandler {
  /// Mostra una SnackBar con un messaggio di errore.
  ///
  /// Parametri:
  /// - `context`: il contesto del widget in cui mostrare la SnackBar.
  /// - `message`: il messaggio di errore da visualizzare.
  static void showErrorSnackBar(String message) {
    // Utilizza un metodo statico per mostrare uno SnackBar senza il BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  /// Mostra un dialogo di errore con un titolo e un messaggio.
  ///
  /// Parametri:
  /// - `context`: il contesto del widget in cui mostrare il dialogo.
  /// - `title`: il titolo del dialogo di errore.
  /// - `message`: il messaggio di errore da visualizzare.
  static void showErrorDialog(String title, String message) {
    // Utilizza un metodo statico per mostrare un AlertDialog senza il BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigatorKey.currentContext;
      if (context != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  /// Mostra una notifica di errore prominente utilizzando un MaterialBanner.
  ///
  /// Parametri:
  /// - `context`: il contesto del widget in cui mostrare la notifica.
  /// - `message`: il messaggio di errore da visualizzare.
  static void showErrorNotification(String message) {
    // Utilizza un metodo statico per mostrare un MaterialBanner senza il BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(message),
            leading: const Icon(
              Icons.error,
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: const Text(
                  'DISMISS',
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
