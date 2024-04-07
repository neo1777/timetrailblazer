/// La classe `WorkEntryDTO` rappresenta un oggetto di trasferimento dati per una voce di lavoro.
class WorkEntryDTO {
  final int? id;
  final DateTime timestamp;
  final bool isEntry;
  final DateTime day;

  WorkEntryDTO({
    this.id,
    required this.timestamp,
    required this.isEntry,
  }) : day = DateTime(timestamp.year, timestamp.month, timestamp.day);

  /// Converte l'oggetto `WorkEntryDTO` in una mappa di chiave-valore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'is_entry': isEntry ? 1 : 0,
    };
  }

  /// Crea un oggetto `WorkEntryDTO` a partire da una mappa di chiave-valore.
  static WorkEntryDTO fromMap(Map<String, dynamic> map) {
    return WorkEntryDTO(
      id: map['id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isEntry: map['is_entry'] == 1,
    );
  }
}