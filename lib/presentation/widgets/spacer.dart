import 'package:flutter/material.dart';

/// Il widget `CustomSpacer` è un wrapper per il widget `Spacer` di Flutter.
///
/// Questo widget accetta il seguente parametro:
/// - `flex`: il fattore di flessibilità del widget.
class CustomSpacer extends StatelessWidget {
  /// Il fattore di flessibilità del widget.
  final int flex;

  /// Costruttore della classe `CustomSpacer`.
  ///
  /// Accetta il seguente parametro:
  /// - `flex`: il fattore di flessibilità del widget. Il valore predefinito è 1.
  const CustomSpacer({super.key, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Spacer(flex: flex);
  }
}
