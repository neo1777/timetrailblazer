// Crea un nuovo file chiamato 'common_body.dart' e aggiungi il seguente codice:

import 'package:flutter/material.dart';

class CommonBody extends StatelessWidget {
  final Widget child;

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
