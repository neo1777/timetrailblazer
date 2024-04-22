import 'package:flutter/material.dart';

/// Il widget `CommonBody` è un contenitore per il contenuto principale dell'applicazione.
///
/// Questo widget accetta il seguente parametro:
/// - `child`: il widget figlio da visualizzare all'interno del contenitore.
class CommonBody extends StatelessWidget {
  /// Il widget figlio da visualizzare all'interno del contenitore.
  final Widget child;

  /// Costruttore della classe `CommonBody`.
  ///
  /// Accetta il seguente parametro:
  /// - `child`: il widget figlio da visualizzare all'interno del contenitore.
  const CommonBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390, maxHeight: 844),
          child: child,
        ),
      ),
    );
  }
}
