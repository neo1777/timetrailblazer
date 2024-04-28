import 'package:flutter/material.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';

/// Il widget `CustomAppBar` è un wrapper per il widget `AppBar` di Flutter.
///
/// Questo widget accetta i seguenti parametri:
/// - `title`: il titolo da visualizzare nella barra delle applicazioni.
/// - `onBackPressed`: la funzione di callback da chiamare quando viene premuto il pulsante "Indietro".
/// - `onAction`: una lista di widget da visualizzare come azioni nella barra delle applicazioni.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Il titolo da visualizzare nella barra delle applicazioni.
  final String title;

  /// La funzione di callback da chiamare quando viene premuto il pulsante "Indietro".
  final VoidCallback? onBackPressed;

  /// Una lista di widget da visualizzare come azioni nella barra delle applicazioni.
  final List<Widget>? onAction;

  /// Costruttore della classe `CustomAppBar`.
  ///
  /// Accetta i seguenti parametri:
  /// - `title`: il titolo da visualizzare nella barra delle applicazioni.
  /// - `onBackPressed`: la funzione di callback da chiamare quando viene premuto il pulsante "Indietro".
  /// - `onAction`: una lista di widget da visualizzare come azioni nella barra delle applicazioni.
  const CustomAppBar({
    super.key,
    this.onBackPressed,
    this.onAction,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      actions: onAction,
      leading: IconButton(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed,
      ),
      title: CustomAutoSizeText(
        title,
        Theme.of(context).textTheme.titleSmall!,
        TextAlign.center,
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(32);
}
