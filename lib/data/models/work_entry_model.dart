/// La classe `WorkEntry` rappresenta il modello di dominio per una voce di lavoro.
class WorkEntryModel {
  /// L'ID univoco della voce di lavoro (può essere null per le nuove voci).
  final int? id;

  /// Il timestamp della voce di lavoro.
  final DateTime timestamp;

  /// Un flag che indica se la voce è un'entrata o un'uscita.
  final bool? isEntry;

  /// La data della voce di lavoro (senza l'ora).
  ///
  /// Rappresenta la data in cui è stata registrata la voce di lavoro, senza includere l'informazione sull'ora specifica.
  /// Viene calcolata automaticamente a partire dal parametro `timestamp` durante la creazione dell'istanza di `WorkEntryModel`.
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

  /// Crea una copia di questa istanza di `WorkEntryModel` con le proprietà specificate modificate.
  ///
  /// Questo metodo consente di creare una nuova istanza di `WorkEntryModel` a partire da un'istanza esistente,
  /// permettendo di modificare solo le proprietà specificate.
  /// I parametri `id`, `timestamp` e `isEntry` sono opzionali. Se non vengono forniti, verranno utilizzati i valori dell'istanza originale.
  ///
  /// Restituisce una nuova istanza di `WorkEntryModel` con le proprietà aggiornate.
  WorkEntryModel copyWith({
    int? id,
    DateTime? timestamp,
    bool? isEntry,
  }) {
    return WorkEntryModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      isEntry: isEntry ?? this.isEntry,
    );
  }
}
