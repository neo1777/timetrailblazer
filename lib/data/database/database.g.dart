// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkEntriesTable extends WorkEntries
    with TableInfo<$WorkEntriesTable, WorkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isEntryMeta =
      const VerificationMeta('isEntry');
  @override
  late final GeneratedColumn<bool> isEntry = GeneratedColumn<bool>(
      'is_entry', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_entry" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, isEntry];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WorkEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_entry')) {
      context.handle(_isEntryMeta,
          isEntry.isAcceptableOrUnknown(data['is_entry']!, _isEntryMeta));
    } else if (isInserting) {
      context.missing(_isEntryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      isEntry: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_entry'])!,
    );
  }

  @override
  $WorkEntriesTable createAlias(String alias) {
    return $WorkEntriesTable(attachedDatabase, alias);
  }
}

class WorkEntry extends DataClass implements Insertable<WorkEntry> {
  /// Colonna per l'ID autogenerato della voce di lavoro.
  final int id;

  /// Colonna per il timestamp della voce di lavoro.
  final DateTime timestamp;

  /// Colonna per il flag di entrata/uscita della voce di lavoro.
  final bool isEntry;
  const WorkEntry(
      {required this.id, required this.timestamp, required this.isEntry});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_entry'] = Variable<bool>(isEntry);
    return map;
  }

  WorkEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      isEntry: Value(isEntry),
    );
  }

  factory WorkEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkEntry(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isEntry: serializer.fromJson<bool>(json['isEntry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isEntry': serializer.toJson<bool>(isEntry),
    };
  }

  WorkEntry copyWith({int? id, DateTime? timestamp, bool? isEntry}) =>
      WorkEntry(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        isEntry: isEntry ?? this.isEntry,
      );
  @override
  String toString() {
    return (StringBuffer('WorkEntry(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('isEntry: $isEntry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, isEntry);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkEntry &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.isEntry == this.isEntry);
}

class WorkEntriesCompanion extends UpdateCompanion<WorkEntry> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<bool> isEntry;
  const WorkEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isEntry = const Value.absent(),
  });
  WorkEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required bool isEntry,
  })  : timestamp = Value(timestamp),
        isEntry = Value(isEntry);
  static Insertable<WorkEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<bool>? isEntry,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (isEntry != null) 'is_entry': isEntry,
    });
  }

  WorkEntriesCompanion copyWith(
      {Value<int>? id, Value<DateTime>? timestamp, Value<bool>? isEntry}) {
    return WorkEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      isEntry: isEntry ?? this.isEntry,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isEntry.present) {
      map['is_entry'] = Variable<bool>(isEntry.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('isEntry: $isEntry')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $WorkEntriesTable workEntries = $WorkEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workEntries];
}
