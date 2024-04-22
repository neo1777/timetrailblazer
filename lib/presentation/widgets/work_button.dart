import 'package:flutter/material.dart';

/// Il widget `WorkButton` rappresenta un pulsante personalizzato per le azioni di entrata e uscita.
class WorkButton extends StatelessWidget {
  /// L'etichetta del pulsante.
  final String label;

  /// La funzione di callback da chiamare quando il pulsante viene premuto.
  final VoidCallback? onPressed;

  /// La larghezza del pulsante.
  final double? width;

  /// Costruttore della classe `WorkButton`.
  ///
  /// Accetta i seguenti parametri:
  /// - `label`: l'etichetta del pulsante.
  /// - `onPressed`: la funzione di callback da chiamare quando il pulsante viene premuto.
  /// - `width`: la larghezza del pulsante.
  const WorkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
        ),
      ),
    );
  }
}
