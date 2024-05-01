import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timetrailblazer/config/constants_string.dart';

class ErrorHandling {
  static void handleError(Object error, Function(String) showErrorCallback) {
    if (error is TimeoutException) {
      showErrorCallback('Timeout Error');
    } else if (error is FormatException) {
      showErrorCallback('Format Error');
    } else {
      showErrorCallback(AppErrorMessages.unexpectedErrorMessage(error.toString()));
    }
  }
  
  static void showErrorDialog(String title, String message, Function(String, String) showDialogCallback) {
    showDialogCallback(title, message);
  }


  static void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}