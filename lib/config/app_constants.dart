import 'package:flutter/material.dart';

// Costanti per i colori
class AppColors {
  // Colori per il tema chiaro
  static const Color primaryColor = Colors.blue;
  //static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  //static const Color cardColor = Colors.white;
  //static const Color textColor = Colors.black;
  static const Color buttonTextColor = Colors.white;
  static const Color errorColor = Colors.red;
  //static const Color successColor = Colors.green;
  static const Color dividerColor = Colors.grey;
  static const Color shadowColor = Colors.black26;
  static const Color entryColor = Colors.green;
  static const Color exitColor = Colors.red;

  // Colori per il tema scuro
  static const Color primaryColorDark = Colors.indigo;
  //static const Color secondaryColorDark = Color(0xFF1E1E1E);
  static const Color backgroundColorDark = Color(0xFF121212);
  //static const Color cardColorDark = Color(0xFF1E1E1E);
  //static const Color textColorDark = Colors.white;
  static const Color buttonTextColorDark = Colors.white;
  static const Color errorColorDark = Colors.redAccent;
  //static const Color successColorDark = Colors.greenAccent;
  static const Color dividerColorDark = Colors.white54;
  static const Color shadowColorDark = Colors.black54;
  static const Color entryColorDark = Colors.greenAccent;
  static const Color exitColorDark = Colors.redAccent;
}

// Costanti per le dimensioni
class AppDimensions {
  static const double buttonPaddingV = 16.0;
  static const double buttonPaddingH = 32.0;
  static const double buttonElevation = 2.0;
  static const double screenPadding = 16.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double buttonFontSize = 18.0;
  static const double buttonBorderRadius = 30.0;
  static const FontWeight buttonFontWeight = FontWeight.bold;
}

// Costanti per i testi
class AppStrings {
  static const String entryRegistered = 'Entrata registrata';
  static const String exitRegistered = 'Uscita registrata';
  static const String appTitle = 'Registrazione Orari di Lavoro';
  static const String homeTitle = 'Registrazione orari di lavoro';
  static const String workEntriesTitle = 'Registrazioni Orari di Lavoro';
  static const String workStatsTitle = 'Statistiche di lavoro';
  static const String confirmResetTitle = 'Conferma Reset';
  static const String confirmResetMessage =
      'Sei sicuro di voler resettare il database? Questa azione è irreversibile.';
  static const String cancelButtonText = 'Annulla';
  static const String confirmButtonText = 'Conferma';
  static const String databaseResetSuccess = 'Database resettato con successo';
  static const String databaseResetError =
      'Errore durante il reset del database:';
  static const String dataLoadError = 'Errore nel caricamento dei dati';
  static const String editWorkEntryTitle = 'Modifica registrazione';
  static const String date = 'Data';
  static const String time = 'Ora';
  static const String selectDate = 'Seleziona data';
  static const String selectTime = 'Seleziona ora';
  static const String save = 'Salva';
  static const String error = 'Errore';
  static const String entryButtonLabel = 'Entrata';
  static const String exitButtonLabel = 'Uscita';
  static const String viewEntriesButtonLabel = 'Visualizza registrazioni';
}

// Costanti per i testi di successo
class AppSuccessMessages {
  static const String csvImportCompleted = 'Importazione CSV completata';
  static const String csvExportCompleted =
      'File CSV esportato correttamente in';
}

// Costanti per i testi di errore
class AppErrorMessages {
  static const String insertEntryError =
      'Errore durante l\'inserimento della voce di lavoro';
  static const String getEntriesError =
      'Errore durante il recupero delle voci di lavoro';
  static const String resetDatabaseError =
      'Errore durante il reset del database';
  static const String invalidDate = 'Data non valida';
  static const String invalidDateMessage =
      'Non è possibile registrare voci di lavoro per date precedenti a ieri. Per favore, seleziona una data valida.';
  static const String invalidTime = 'Orario non valido';
  static const String invalidTimeMessage =
      'Non è possibile selezionare un orario futuro. Per favore, seleziona un orario valido.';
  static const String updateError = 'Errore di aggiornamento';
  static String updateErrorMessage(String message) =>
      'Errore durante l\'aggiornamento della voce di lavoro: $message. Si prega di verificare i dati inseriti e riprovare. Se il problema persiste, contattare l\'assistenza.';
  static const String registrationError = 'Errore di registrazione';
  static String registrationErrorMessage(String message) =>
      'Errore durante la registrazione della voce di lavoro: $message. Si prega di verificare i dati inseriti e riprovare. Se il problema persiste, contattare l\'assistenza.';
  static const String csvExportError = 'Errore durante l\'esportazione CSV:';
  static const String csvImportError = 'Errore durante l\'importazione CSV:';
  static const String csvSelectError =
      'Errore durante la selezione del file CSV. Per favore, riprova e seleziona un file CSV valido.';
  static const String csvSelectNullError =
      'Nessun file CSV selezionato. Per favore, seleziona un file CSV per l\'importazione.';
  static const String fetchEntriesError =
      'Errore durante il recupero delle voci di lavoro';
  static String fetchEntriesErrorMessage(String message) =>
      'Errore durante il recupero delle voci di lavoro: $message. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.';
  static const String workEntriesOperationError =
      'Errore durante l\'operazione sulle voci di lavoro';
  static String workEntriesOperationErrorMessage(String message) =>
      'Errore durante l\'operazione sulle voci di lavoro: $message. Si prega di verificare la connessione di rete e riprovare. Se il problema persiste, contattare l\'assistenza.';
  static const String loadStatsError =
      'Errore durante il caricamento delle statistiche';
  static const String retryOrCheckNetwork =
      'Si prega di riprovare più tardi o verificare la connessione di rete.';
  static const String checkStorageAndPermissions =
      'Si prega di verificare che ci sia spazio sufficiente sul dispositivo e che l\'applicazione abbia i permessi necessari per scrivere i file.';
  static const String csvFileNotFound = 'File CSV non trovato';
  static const String emptyCsvFile = 'File CSV vuoto';
  static const String retryLater = 'Si prega di riprovare più tardi.';
  static const updateDateError =
      'Errore durante l\'aggiornamento della data della voce di lavoro';
  static updateDateErrorMessage(String message) =>
      'Errore durante l\'aggiornamento della data della voce di lavoro: $message. Si prega di verificare la data selezionata e riprovare.';
  static const updateTimeError =
      'Errore durante l\'aggiornamento dell\'ora della voce di lavoro';
  static updateTimeErrorMessage(String message) =>
      'Errore durante l\'aggiornamento dell\'ora della voce di lavoro: $message. Si prega di verificare l\'ora selezionata e riprovare.';
  static const providerInsertError =
      'Errore durante l\'inserimento della voce di lavoro';
  static providerInsertErrorMessage(String message) =>
      'Errore durante l\'inserimento della voce di lavoro: $message';
  static const providerGetError =
      'Errore durante il recupero delle voci di lavoro';
  static providerGetErrorMessage(String message) =>
      'Errore durante il recupero delle voci di lavoro: $message';
  static const providerDeleteAllError =
      'Errore durante l\'eliminazione di tutte le voci di lavoro';
  static providerDeleteAllErrorMessage(String message) =>
      'Errore durante l\'eliminazione di tutte le voci di lavoro: $message';
  static const providerDeleteError =
      'Errore durante l\'eliminazione della voce di lavoro';
  static providerDeleteErrorMessage(String message) =>
      'Errore durante l\'eliminazione della voce di lavoro: $message';
  static const providerUpdateError =
      'Errore durante l\'aggiornamento della voce di lavoro';
  static providerUpdateErrorMessage(String message) =>
      'Errore durante l\'aggiornamento della voce di lavoro: $message';
  static const providerGetLastError =
      'Errore durante il recupero dell\'ultima voce di lavoro';
  static providerGetLastErrorMessage(String message) =>
      'Errore durante il recupero dell\'ultima voce di lavoro: $message';
  static const repositoryInsertError =
      'Errore durante l\'inserimento della voce di lavoro nel repository';
  static repositoryInsertErrorMessage(String message) =>
      'Errore durante l\'inserimento della voce di lavoro nel repository: $message';
  static const repositoryGetError =
      'Errore durante il recupero delle voci di lavoro nel repository';
  static repositoryGetErrorMessage(String message) =>
      'Errore durante il recupero delle voci di lavoro nel repository: $message';
  static const repositoryDeleteAllError =
      'Errore durante l\'eliminazione di tutte le voci di lavoro nel repository';
  static repositoryDeleteAllErrorMessage(String message) =>
      'Errore durante l\'eliminazione di tutte le voci di lavoro nel repository: $message';
  static const repositoryDeleteError =
      'Errore durante l\'eliminazione della voce di lavoro nel repository';
  static repositoryDeleteErrorMessage(String message) =>
      'Errore durante l\'eliminazione della voce di lavoro nel repository: $message';
  static const repositoryUpdateError =
      'Errore durante l\'aggiornamento della voce di lavoro nel repository';
  static repositoryUpdateErrorMessage(String message) =>
      'Errore durante l\'aggiornamento della voce di lavoro nel repository: $message';
  static const repositoryGetLastError =
      'Errore durante il recupero dell\'ultima voce di lavoro nel repository';
  static repositoryGetLastErrorMessage(String message) =>
      'Errore durante il recupero dell\'ultima voce di lavoro nel repository: $message';
  static const repositoryExportError =
      'Errore durante l\'esportazione delle voci di lavoro in CSV';
  static repositoryExportErrorMessage(String message) =>
      'Errore durante l\'esportazione delle voci di lavoro in CSV: $message';
  static const repositoryImportError =
      'Errore durante l\'importazione delle voci di lavoro da CSV';
  static repositoryImportErrorMessage(String message) =>
      'Errore durante l\'importazione delle voci di lavoro da CSV: $message';
  static const repositoryCalculateError =
      'Errore durante il calcolo del tempo di lavoro';
  static repositoryCalculateErrorMessage(String message) =>
      'Errore durante il calcolo del tempo di lavoro: $message';
}