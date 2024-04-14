import 'package:flutter/material.dart';
import 'package:timetrailblazer/config/app_constants.dart';

/// Il widget `WorkButton` rappresenta un pulsante personalizzato per le azioni di entrata e uscita.
class WorkButton extends StatelessWidget {
  /// L'etichetta del pulsante.
  final String label;

  /// La funzione di callback da chiamare quando il pulsante viene premuto.
  final VoidCallback? onPressed;

  /// La larghezza del pulsante.
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
          foregroundColor: AppColors.primaryColor,
          backgroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.buttonBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.buttonPaddingV,
            horizontal: AppDimensions.buttonPaddingH,
          ),
          elevation: AppDimensions.buttonElevation,
          shadowColor: AppColors.shadowColor.withOpacity(0.2),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.buttonFontSize,
            fontWeight: AppDimensions.buttonFontWeight,
          ),
        ),
      ),
    );
  }
}
