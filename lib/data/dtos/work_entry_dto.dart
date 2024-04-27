/// La classe `WorkEntryDTO` rappresenta l'oggetto di trasferimento dati (DTO) per una voce di lavoro.
///
/// Un DTO è un oggetto che contiene i dati nella forma richiesta per il trasferimento tra diversi strati dell'applicazione,
/// come il database o le API esterne. La classe `WorkEntryDTO` definisce la struttura dei dati per una voce di lavoro
/// e fornisce metodi per la conversione da e verso un formato di mappa chiave-valore.
class WorkEntryDTO {
  /// L'ID univoco della voce di lavoro (può essere null per le nuove voci).
  final int? id;

  /// Il timestamp della voce di lavoro in millisecondi.
  final int timestamp;

/// Un flag che indica se la voce è un'entrata (1) o un'uscita (0).
  ///
  /// - Il valore 1 rappresenta un'entrata, ovvero quando l'utente inizia un turno di lavoro.
  /// - Il valore 0 rappresenta un'uscita, ovvero quando l'utente termina un turno di lavoro.
  final int isEntry;

  /// Costruttore della classe `WorkEntryDTO`.
  ///
  /// Accetta i seguenti parametri:
  /// - [id]: l'ID univoco della voce di lavoro (opzionale).
  /// - [timestamp]: il timestamp della voce di lavoro in millisecondi.
  /// - [isEntry]: un flag che indica se la voce è un'entrata (1) o un'uscita (0).
  WorkEntryDTO({
    this.id,
    required this.timestamp,
    required this.isEntry,
  });

  /// Converte l'oggetto `WorkEntryDTO` in una mappa chiave-valore.
  ///
  /// Restituisce una mappa con le seguenti chiavi:
  /// - 'id': l'ID univoco della voce di lavoro.
  /// - 'timestamp': il timestamp della voce di lavoro in millisecondi.
  /// - 'isEntry': un flag che indica se la voce è un'entrata (1) o un'uscita (0).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'isEntry': isEntry,
    };
  }

  /// Crea un oggetto `WorkEntryDTO` a partire da una mappa chiave-valore.
  ///
  /// Accetta una mappa con le seguenti chiavi:
  /// - 'id': l'ID univoco della voce di lavoro.
  /// - 'timestamp': il timestamp della voce di lavoro in millisecondi.
  /// - 'isEntry': un flag che indica se la voce è un'entrata (1) o un'uscita (0).
  ///
  /// Restituisce un nuovo oggetto `WorkEntryDTO` inizializzato con i valori della mappa.
  factory WorkEntryDTO.fromMap(Map<String, dynamic> map) {
    return WorkEntryDTO(
      id: map['id'],
      timestamp: map['timestamp'],
      isEntry: map['isEntry'],
    );
  }
}
