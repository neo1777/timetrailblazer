/// La classe `WorkEntry` rappresenta il modello di dominio per una voce di lavoro.
class WorkEntryModel {
  /// L'ID univoco della voce di lavoro (può essere null per le nuove voci).
  final int? id;

  /// Il timestamp della voce di lavoro.
  final DateTime timestamp;

  /// Un flag che indica se la voce è un'entrata o un'uscita.
  final bool? isEntry;

  /// La data della voce di lavoro (senza l'ora).
  final DateTime day;

  /// Costruttore della classe `WorkEntry`.
  ///
  /// Accetta i seguenti parametri:
  /// - [id]: l'ID univoco della voce di lavoro (opzionale).
  /// - [timestamp]: il timestamp della voce di lavoro.
  /// - [isEntry]: un flag che indica se la voce è un'entrata o un'uscita.
  ///
  /// Calcola automaticamente la proprietà [day] a partire dal [timestamp].
  WorkEntryModel({
    this.id,
    required this.timestamp,
    required this.isEntry,
  }) : day = DateTime(timestamp.year, timestamp.month, timestamp.day);
}
