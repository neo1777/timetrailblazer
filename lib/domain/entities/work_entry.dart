import 'package:equatable/equatable.dart';

/// La classe `WorkEntry` rappresenta una voce di lavoro.
class WorkEntry extends Equatable {
  /// L'ID univoco della voce di lavoro (può essere null per le nuove voci).
  final int? id;

  /// Il timestamp della voce di lavoro.
  final DateTime timestamp;

  /// Un flag che indica se la voce è un'entrata o un'uscita.
  final bool isEntry;

  /// La data della voce di lavoro (senza l'ora).
  final DateTime day;

  /// Costruttore della classe `WorkEntry`.
  WorkEntry({
    this.id,
    required this.timestamp,
    required this.isEntry,
  }) : day = DateTime(timestamp.year, timestamp.month, timestamp.day);

  /// Crea una copia della voce di lavoro con i valori specificati.
  WorkEntry copyWith({
    int? id,
    DateTime? timestamp,
    bool? isEntry,
  }) {
    return WorkEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      isEntry: isEntry ?? this.isEntry,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, isEntry, day];
}
