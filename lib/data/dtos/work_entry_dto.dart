/// La classe `WorkEntryDTO` rappresenta l'oggetto di trasferimento dati (DTO) per una voce di lavoro.
class WorkEntryDTO {
  /// L'ID univoco della voce di lavoro (può essere null per le nuove voci).
  final int? id;

  /// Il timestamp della voce di lavoro in millisecondi.
  final int timestamp;

  /// Un flag che indica se la voce è un'entrata (1) o un'uscita (0).
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
