/// La classe `AppStrings` contiene le costanti per i testi utilizzati nell'applicazione.
/// Queste stringhe sono utilizzate per garantire la coerenza del testo in tutta l'app e facilitare eventuali modifiche.
class AppStrings {
  static const String entryRegistered = 'Entrata registrata';
  static const String exitRegistered = 'Uscita registrata';
  static const String appName = 'TimeTrailblazer';
  static const String appFooter =
      'TimeTrailblazer - L\'app per una gestione del tempo impeccabile, sviluppata da Neo1777.';
  static const String appTitle = 'Registrazione Orari di Lavoro';
  static const String homeTitle = 'Registrazione orari di lavoro';
  static const String appDescription =
      'L\'app essenziale per tracciare i tuoi orari di lavoro.';
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

/// La classe `AppSuccessMessages` contiene le costanti per i messaggi di successo dell'applicazione.
/// Utilizzate per fornire feedback positivo all'utente in risposta alle sue azioni.
class AppSuccessMessages {
  static const String csvImportCompleted = 'Importazione CSV completata';
  static const String csvExportCompleted =
      'File CSV esportato correttamente in';
}

/// La classe `AppErrorMessages` contiene le costanti per i messaggi di errore dell'applicazione.
/// Questi messaggi aiutano a informare l'utente di problemi o errori durante l'utilizzo dell'app.
class AppErrorMessages {
  static const String unexpectedError = 'Si è verificato un errore imprevisto.';
  static String unexpectedErrorMessage(String message) =>
      'Si è verificato un errore imprevisto: $message. Si prega di contattare l\'assistenza.';
  static const String errorOccurred = 'Si è verificato un errore';
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
