// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_matrix_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDecisionMatrixRecordCollection on Isar {
  IsarCollection<DecisionMatrixRecord> get decisionMatrixRecords =>
      this.collection();
}

const DecisionMatrixRecordSchema = CollectionSchema(
  name: r'DecisionMatrixRecord',
  id: 7353389952279303013,
  properties: {
    r'calibrationSummary': PropertySchema(
      id: 0,
      name: r'calibrationSummary',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'decisionId': PropertySchema(
      id: 2,
      name: r'decisionId',
      type: IsarType.string,
    ),
    r'events': PropertySchema(
      id: 3,
      name: r'events',
      type: IsarType.objectList,
      target: r'DecisionEvent',
    ),
    r'firstActionDue': PropertySchema(
      id: 4,
      name: r'firstActionDue',
      type: IsarType.dateTime,
    ),
    r'lastReviewedAt': PropertySchema(
      id: 5,
      name: r'lastReviewedAt',
      type: IsarType.dateTime,
    ),
    r'nextStep': PropertySchema(
      id: 6,
      name: r'nextStep',
      type: IsarType.string,
    ),
    r'outcome': PropertySchema(
      id: 7,
      name: r'outcome',
      type: IsarType.byte,
      enumMap: _DecisionMatrixRecordoutcomeEnumValueMap,
    ),
    r'protocolLabel': PropertySchema(
      id: 8,
      name: r'protocolLabel',
      type: IsarType.string,
    ),
    r'rawJson': PropertySchema(
      id: 9,
      name: r'rawJson',
      type: IsarType.string,
    ),
    r'reviewDate': PropertySchema(
      id: 10,
      name: r'reviewDate',
      type: IsarType.dateTime,
    ),
    r'reviewNotes': PropertySchema(
      id: 11,
      name: r'reviewNotes',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 12,
      name: r'sessionId',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _decisionMatrixRecordEstimateSize,
  serialize: _decisionMatrixRecordSerialize,
  deserialize: _decisionMatrixRecordDeserialize,
  deserializeProp: _decisionMatrixRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'decisionId': IndexSchema(
      id: 5949350061253174314,
      name: r'decisionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'decisionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'DecisionEvent': DecisionEventSchema},
  getId: _decisionMatrixRecordGetId,
  getLinks: _decisionMatrixRecordGetLinks,
  attach: _decisionMatrixRecordAttach,
  version: '3.1.0+1',
);

int _decisionMatrixRecordEstimateSize(
  DecisionMatrixRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.calibrationSummary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.decisionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.events.length * 3;
  {
    final offsets = allOffsets[DecisionEvent]!;
    for (var i = 0; i < object.events.length; i++) {
      final value = object.events[i];
      bytesCount +=
          DecisionEventSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.nextStep;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.protocolLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reviewNotes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _decisionMatrixRecordSerialize(
  DecisionMatrixRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.calibrationSummary);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.decisionId);
  writer.writeObjectList<DecisionEvent>(
    offsets[3],
    allOffsets,
    DecisionEventSchema.serialize,
    object.events,
  );
  writer.writeDateTime(offsets[4], object.firstActionDue);
  writer.writeDateTime(offsets[5], object.lastReviewedAt);
  writer.writeString(offsets[6], object.nextStep);
  writer.writeByte(offsets[7], object.outcome.index);
  writer.writeString(offsets[8], object.protocolLabel);
  writer.writeString(offsets[9], object.rawJson);
  writer.writeDateTime(offsets[10], object.reviewDate);
  writer.writeString(offsets[11], object.reviewNotes);
  writer.writeLong(offsets[12], object.sessionId);
  writer.writeString(offsets[13], object.title);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

DecisionMatrixRecord _decisionMatrixRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DecisionMatrixRecord();
  object.calibrationSummary = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTimeOrNull(offsets[1]);
  object.decisionId = reader.readStringOrNull(offsets[2]);
  object.events = reader.readObjectList<DecisionEvent>(
        offsets[3],
        DecisionEventSchema.deserialize,
        allOffsets,
        DecisionEvent(),
      ) ??
      [];
  object.firstActionDue = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.lastReviewedAt = reader.readDateTimeOrNull(offsets[5]);
  object.nextStep = reader.readStringOrNull(offsets[6]);
  object.outcome = _DecisionMatrixRecordoutcomeValueEnumMap[
          reader.readByteOrNull(offsets[7])] ??
      DecisionOutcome.pending;
  object.protocolLabel = reader.readStringOrNull(offsets[8]);
  object.rawJson = reader.readStringOrNull(offsets[9]);
  object.reviewDate = reader.readDateTimeOrNull(offsets[10]);
  object.reviewNotes = reader.readStringOrNull(offsets[11]);
  object.sessionId = reader.readLongOrNull(offsets[12]);
  object.title = reader.readStringOrNull(offsets[13]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[14]);
  return object;
}

P _decisionMatrixRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<DecisionEvent>(
            offset,
            DecisionEventSchema.deserialize,
            allOffsets,
            DecisionEvent(),
          ) ??
          []) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_DecisionMatrixRecordoutcomeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DecisionOutcome.pending) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DecisionMatrixRecordoutcomeEnumValueMap = {
  'pending': 0,
  'success': 1,
  'failure': 2,
  'ambiguous': 3,
};
const _DecisionMatrixRecordoutcomeValueEnumMap = {
  0: DecisionOutcome.pending,
  1: DecisionOutcome.success,
  2: DecisionOutcome.failure,
  3: DecisionOutcome.ambiguous,
};

Id _decisionMatrixRecordGetId(DecisionMatrixRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _decisionMatrixRecordGetLinks(
    DecisionMatrixRecord object) {
  return [];
}

void _decisionMatrixRecordAttach(
    IsarCollection<dynamic> col, Id id, DecisionMatrixRecord object) {
  object.id = id;
}

extension DecisionMatrixRecordByIndex on IsarCollection<DecisionMatrixRecord> {
  Future<DecisionMatrixRecord?> getByDecisionId(String? decisionId) {
    return getByIndex(r'decisionId', [decisionId]);
  }

  DecisionMatrixRecord? getByDecisionIdSync(String? decisionId) {
    return getByIndexSync(r'decisionId', [decisionId]);
  }

  Future<bool> deleteByDecisionId(String? decisionId) {
    return deleteByIndex(r'decisionId', [decisionId]);
  }

  bool deleteByDecisionIdSync(String? decisionId) {
    return deleteByIndexSync(r'decisionId', [decisionId]);
  }

  Future<List<DecisionMatrixRecord?>> getAllByDecisionId(
      List<String?> decisionIdValues) {
    final values = decisionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'decisionId', values);
  }

  List<DecisionMatrixRecord?> getAllByDecisionIdSync(
      List<String?> decisionIdValues) {
    final values = decisionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'decisionId', values);
  }

  Future<int> deleteAllByDecisionId(List<String?> decisionIdValues) {
    final values = decisionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'decisionId', values);
  }

  int deleteAllByDecisionIdSync(List<String?> decisionIdValues) {
    final values = decisionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'decisionId', values);
  }

  Future<Id> putByDecisionId(DecisionMatrixRecord object) {
    return putByIndex(r'decisionId', object);
  }

  Id putByDecisionIdSync(DecisionMatrixRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'decisionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDecisionId(List<DecisionMatrixRecord> objects) {
    return putAllByIndex(r'decisionId', objects);
  }

  List<Id> putAllByDecisionIdSync(List<DecisionMatrixRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'decisionId', objects, saveLinks: saveLinks);
  }
}

extension DecisionMatrixRecordQueryWhereSort
    on QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QWhere> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DecisionMatrixRecordQueryWhere
    on QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QWhereClause> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      decisionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'decisionId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      decisionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      decisionIdEqualTo(String? decisionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'decisionId',
        value: [decisionId],
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterWhereClause>
      decisionIdNotEqualTo(String? decisionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionId',
              lower: [],
              upper: [decisionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionId',
              lower: [decisionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionId',
              lower: [decisionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionId',
              lower: [],
              upper: [decisionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DecisionMatrixRecordQueryFilter on QueryBuilder<DecisionMatrixRecord,
    DecisionMatrixRecord, QFilterCondition> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calibrationSummary',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calibrationSummary',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calibrationSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      calibrationSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'calibrationSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      calibrationSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'calibrationSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calibrationSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> calibrationSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'calibrationSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decisionId',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decisionId',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decisionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      decisionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decisionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      decisionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decisionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionId',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> decisionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decisionId',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstActionDue',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstActionDue',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstActionDue',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstActionDue',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstActionDue',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> firstActionDueBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstActionDue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastReviewedAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastReviewedAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> lastReviewedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReviewedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextStep',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextStep',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextStep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      nextStepContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextStep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      nextStepMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextStep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextStep',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> nextStepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextStep',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> outcomeEqualTo(DecisionOutcome value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> outcomeGreaterThan(
    DecisionOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> outcomeLessThan(
    DecisionOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> outcomeBetween(
    DecisionOutcome lower,
    DecisionOutcome upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'protocolLabel',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'protocolLabel',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protocolLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      protocolLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      protocolLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'protocolLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> protocolLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'protocolLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawJson',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawJson',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      rawJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      rawJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> rawJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reviewDate',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reviewDate',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reviewNotes',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reviewNotes',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      reviewNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reviewNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      reviewNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reviewNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> reviewNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reviewNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> sessionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DecisionMatrixRecordQueryObject on QueryBuilder<DecisionMatrixRecord,
    DecisionMatrixRecord, QFilterCondition> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord,
      QAfterFilterCondition> eventsElement(FilterQuery<DecisionEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'events');
    });
  }
}

extension DecisionMatrixRecordQueryLinks on QueryBuilder<DecisionMatrixRecord,
    DecisionMatrixRecord, QFilterCondition> {}

extension DecisionMatrixRecordQuerySortBy
    on QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QSortBy> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByCalibrationSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calibrationSummary', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByCalibrationSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calibrationSummary', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByDecisionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByDecisionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByFirstActionDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActionDue', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByFirstActionDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActionDue', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByLastReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByLastReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewedAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByNextStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextStep', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByNextStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextStep', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByProtocolLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByProtocolLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByRawJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByRawJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByReviewNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewNotes', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByReviewNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewNotes', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DecisionMatrixRecordQuerySortThenBy
    on QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QSortThenBy> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByCalibrationSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calibrationSummary', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByCalibrationSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calibrationSummary', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByDecisionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByDecisionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByFirstActionDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActionDue', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByFirstActionDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActionDue', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByLastReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByLastReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewedAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByNextStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextStep', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByNextStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextStep', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByProtocolLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByProtocolLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByRawJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByRawJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawJson', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByReviewNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewNotes', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByReviewNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewNotes', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DecisionMatrixRecordQueryWhereDistinct
    on QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct> {
  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByCalibrationSummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calibrationSummary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByDecisionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decisionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByFirstActionDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstActionDue');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByLastReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReviewedAt');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByNextStep({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextStep', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByProtocolLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protocolLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByRawJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewDate');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByReviewNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewNotes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionMatrixRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DecisionMatrixRecordQueryProperty on QueryBuilder<
    DecisionMatrixRecord, DecisionMatrixRecord, QQueryProperty> {
  QueryBuilder<DecisionMatrixRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      calibrationSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calibrationSummary');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      decisionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decisionId');
    });
  }

  QueryBuilder<DecisionMatrixRecord, List<DecisionEvent>, QQueryOperations>
      eventsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'events');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DateTime?, QQueryOperations>
      firstActionDueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstActionDue');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DateTime?, QQueryOperations>
      lastReviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReviewedAt');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      nextStepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextStep');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DecisionOutcome, QQueryOperations>
      outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      protocolLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protocolLabel');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      rawJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawJson');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DateTime?, QQueryOperations>
      reviewDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewDate');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      reviewNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewNotes');
    });
  }

  QueryBuilder<DecisionMatrixRecord, int?, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<DecisionMatrixRecord, String?, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<DecisionMatrixRecord, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
