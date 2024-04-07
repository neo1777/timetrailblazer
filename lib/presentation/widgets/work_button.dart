import 'package:flutter/material.dart';
import 'package:timetrailblazer/constants.dart';

/// Il widget `WorkButton` rappresenta un pulsante personalizzato per le azioni di entrata e uscita.
class WorkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;

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
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: buttonPaddingV,
            horizontal: buttonPaddingH,
          ),
          elevation: buttonElevation,
          shadowColor: shadowColor.withOpacity(0.2),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
