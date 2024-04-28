/// La classe `WorkStatsDTO` rappresenta l'oggetto di trasferimento dati (DTO) per le statistiche di lavoro.
///
/// Un DTO è un oggetto che contiene i dati nella forma richiesta per il trasferimento tra diversi strati dell'applicazione,
/// come il database o le API esterne. La classe `WorkStatsDTO` definisce la struttura dei dati per le statistiche di lavoro,
/// includendo informazioni sulla data, l'anno, il mese e le ore lavorate e di straordinario.
class WorkStatsDTO {
  /// La data delle statistiche in millisecondi.
  final int? date;

  /// L'anno delle statistiche (utilizzato per le statistiche mensili).
  ///
  /// Questo parametro è opzionale e viene utilizzato solo per le statistiche mensili,
  /// dove rappresenta l'anno a cui si riferiscono le statistiche.
  final int? year;

  /// Il mese delle statistiche (utilizzato per le statistiche mensili).
  ///
  /// Questo parametro è opzionale e viene utilizzato solo per le statistiche mensili,
  /// dove rappresenta il mese (1-12) a cui si riferiscono le statistiche.
  final int? month;

  /// Il totale delle ore lavorate in millisecondi.
  ///
  /// Rappresenta la somma totale delle ore lavorate per il periodo di tempo specificato (giorno, mese o intervallo selezionato).
  /// Il valore è espresso in millisecondi per consentire calcoli precisi e flessibili.
  final int workedSeconds;

  /// Il totale delle ore di straordinario in millisecondi.
  ///
  /// Rappresenta la somma totale delle ore di straordinario lavorate per il periodo di tempo specificato (giorno, mese o intervallo selezionato).
  /// Il valore è espresso in millisecondi per consentire calcoli precisi e flessibili.
  final int overtimeSeconds;

  /// Costruttore della classe `WorkStatsDTO`.
  ///
  /// Accetta i seguenti parametri:
  /// - [date]: la data delle statistiche in millisecondi.
  /// - [year]: l'anno delle statistiche (utilizzato per le statistiche mensili).
  /// - [month]: il mese delle statistiche (utilizzato per le statistiche mensili).
  /// - [workedMillis]: il totale delle ore lavorate in millisecondi.
  /// - [overtimeMillis]: il totale delle ore di straordinario in millisecondi.
  WorkStatsDTO({
    this.date,
    this.year,
    this.month,
    required this.workedSeconds,
    required this.overtimeSeconds,
  });

  /// Crea un oggetto `WorkStatsDTO` a partire da una mappa chiave-valore.
  ///
  /// Accetta una mappa con le seguenti chiavi:
  /// - 'date': la data delle statistiche in millisecondi.
  /// - 'year': l'anno delle statistiche (utilizzato per le statistiche mensili).
  /// - 'month': il mese delle statistiche (utilizzato per le statistiche mensili).
  /// - 'workedMillis': il totale delle ore lavorate in millisecondi.
  /// - 'overtimeMillis': il totale delle ore di straordinario in millisecondi.
  ///
  /// Restituisce un nuovo oggetto `WorkStatsDTO` inizializzato con i valori della mappa.
  factory WorkStatsDTO.fromMap(Map<String, dynamic> map) {
    return WorkStatsDTO(
      date: map['date'] != null
          ? DateTime.parse(map['date']).millisecondsSinceEpoch
          : null,
      year: map['year'],
      month: map['month'],
      workedSeconds: map['workedSeconds'] ?? 0,
      overtimeSeconds: map['overtimeSeconds'] ?? 0,
    );
  }
}
