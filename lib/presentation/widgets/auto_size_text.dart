import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Il widget `CustomAutoSizeText` è un wrapper per il widget `AutoSizeText` di Flutter.
///
/// Questo widget accetta i seguenti parametri:
/// - `text`: il testo da visualizzare.
/// - `style`: lo stile del testo.
/// - `textAlign`: l'allineamento del testo.
class CustomAutoSizeText extends StatelessWidget {
  /// Il testo da visualizzare.
  final String text;

  /// Lo stile del testo.
  final TextStyle style;

  /// L'allineamento del testo.
  final TextAlign textAlign;

  final int? maxLines;

  /// Costruttore della classe `CustomAutoSizeText`.
  ///
  /// Accetta i seguenti parametri:
  /// - `text`: il testo da visualizzare.
  /// - `style`: lo stile del testo.
  /// - `textAlign`: l'allineamento del testo.
  const CustomAutoSizeText(this.text, this.style, this.textAlign, this.maxLines,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: style,
      minFontSize: 0,
      maxLines: maxLines,
      overflow: TextOverflow.fade,
    );
  }
}
