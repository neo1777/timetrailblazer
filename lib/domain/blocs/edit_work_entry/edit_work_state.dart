part of 'edit_work_bloc.dart';

/// La classe base astratta per gli stati del BLoC `EditWorkBloc`.
///
/// Tutti gli stati del BLoC devono estendere questa classe.
///
/// Implementa `Equatable` per consentire il confronto tra gli stati.
abstract class EditWorkState extends Equatable {
  /// Restituisce una lista di oggetti che rappresentano le proprietà dell'oggetto stato.
  ///
  /// Questa lista viene utilizzata da `Equatable` per determinare l'uguaglianza tra gli stati.
  ///
  /// Per impostazione predefinita, restituisce una lista vuota.
  @override
  List<Object?> get props => [];
}

/// Stato iniziale del BLoC `EditWorkBloc`.
///
/// Questo stato viene emesso quando il BLoC viene inizializzato.
class EditWorkInitial extends EditWorkState {}

/// Stato che indica che è in corso il caricamento dei dati della voce di lavoro.
///
/// Questo stato viene emesso quando il BLoC sta caricando i dati della voce di lavoro dal repository.
class EditWorkLoading extends EditWorkState {}

/// Stato che rappresenta i dati modificati della voce di lavoro.
///
/// Questo stato viene emesso quando i dati della voce di lavoro sono stati modificati,
/// ad esempio quando viene modificata la data o l'ora.
///
/// Contiene la voce di lavoro modificata e un flag `isSaveEnabled` che indica se il pulsante
/// di salvataggio deve essere abilitato o meno.
class EditWorkDataChanged extends EditWorkState {
  /// La voce di lavoro modificata.
  final WorkEntryModel workEntry;

  /// Flag che indica se il pulsante di salvataggio deve essere abilitato.
  final bool isSaveEnabled;

  /// Costruttore della classe `EditWorkDataChanged`.
  ///
  /// Accetta la voce di lavoro modificata come parametro obbligatorio e un flag opzionale
  /// `isSaveEnabled` che indica se il pulsante di salvataggio deve essere abilitato.
  EditWorkDataChanged({required this.workEntry, this.isSaveEnabled = false});

  /// Restituisce una lista di oggetti che rappresentano le proprietà dell'oggetto stato.
  ///
  /// Questa lista viene utilizzata da `Equatable` per determinare l'uguaglianza tra gli stati.
  ///
  /// Include la voce di lavoro modificata e il flag `isSaveEnabled`.
  @override
  List<Object> get props => [workEntry, isSaveEnabled];
}

/// Stato che indica che il salvataggio della voce di lavoro è stato completato con successo.
///
/// Questo stato viene emesso quando la voce di lavoro modificata è stata salvata correttamente
/// nel repository.
class EditWorkSaved extends EditWorkState {}

/// Stato che rappresenta un errore durante la modifica della voce di lavoro.
///
/// Questo stato viene emesso quando si verifica un errore durante il caricamento, la modifica
/// o il salvataggio della voce di lavoro.
///
/// Contiene un messaggio di errore che descrive l'errore verificatosi.
class EditWorkError extends EditWorkState {
  /// Il messaggio di errore.
  final String message;

  /// Costruttore della classe `EditWorkError`.
  ///
  /// Accetta il messaggio di errore come parametro obbligatorio.
  EditWorkError({required this.message});

  /// Restituisce una lista di oggetti che rappresentano le proprietà dell'oggetto stato.
  ///
  /// Questa lista viene utilizzata da `Equatable` per determinare l'uguaglianza tra gli stati.
  ///
  /// Include il messaggio di errore.
  @override
  List<Object> get props => [message];
}