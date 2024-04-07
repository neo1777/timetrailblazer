import 'package:flutter/material.dart';

// Costanti per i colori
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.white;
const Color errorColor = Colors.red;
const Color shadowColor = Colors.black;
const Color entryColor = Colors.green;
const Color exitColor = Colors.red;

// Costanti per le dimensioni
const double buttonPaddingV = 16.0;
const double buttonPaddingH = 32.0;
const double buttonElevation = 2.0;

// Costanti per i testi
const String entryRegistered = 'Entrata registrata';
const String exitRegistered = 'Uscita registrata';
const String appTitle = 'Registrazione Orari di Lavoro';
const String homeTitle = 'Registrazione orari di lavoro';
const String workEntriesTitle = 'Registrazioni Orari di Lavoro';
const String confirmResetTitle = 'Conferma Reset';
const String confirmResetMessage =
    'Sei sicuro di voler resettare il database? Questa azione è irreversibile.';
const String cancelButtonText = 'Annulla';
const String confirmButtonText = 'Conferma';
const String csvExportSuccess = 'File CSV esportato in';
const String csvExportError = 'Errore durante l\'esportazione CSV:';
const String databaseResetSuccess = 'Database resettato con successo';
const String databaseResetError = 'Errore durante il reset del database:';
const String dataLoadError = 'Errore nel caricamento dei dati';

// Costanti per le notifiche di errore
const String insertEntryError =
    'Errore durante l\'inserimento della voce di lavoro';
const String getEntriesError =
    'Errore durante il recupero delle voci di lavoro';
const String resetDatabaseError = 'Errore durante il reset del database';
