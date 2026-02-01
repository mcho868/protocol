// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_draft.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDecisionDraftCollection on Isar {
  IsarCollection<DecisionDraft> get decisionDrafts => this.collection();
}

const DecisionDraftSchema = CollectionSchema(
  name: r'DecisionDraft',
  id: 5473773575914726363,
  properties: {
    r'dataJson': PropertySchema(
      id: 0,
      name: r'dataJson',
      type: IsarType.string,
    ),
    r'events': PropertySchema(
      id: 1,
      name: r'events',
      type: IsarType.objectList,
      target: r'DecisionEvent',
    ),
    r'missingFields': PropertySchema(
      id: 2,
      name: r'missingFields',
      type: IsarType.stringList,
    ),
    r'sessionId': PropertySchema(
      id: 3,
      name: r'sessionId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _decisionDraftEstimateSize,
  serialize: _decisionDraftSerialize,
  deserialize: _decisionDraftDeserialize,
  deserializeProp: _decisionDraftDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'DecisionEvent': DecisionEventSchema},
  getId: _decisionDraftGetId,
  getLinks: _decisionDraftGetLinks,
  attach: _decisionDraftAttach,
  version: '3.1.0+1',
);

int _decisionDraftEstimateSize(
  DecisionDraft object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dataJson;
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
  bytesCount += 3 + object.missingFields.length * 3;
  {
    for (var i = 0; i < object.missingFields.length; i++) {
      final value = object.missingFields[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _decisionDraftSerialize(
  DecisionDraft object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dataJson);
  writer.writeObjectList<DecisionEvent>(
    offsets[1],
    allOffsets,
    DecisionEventSchema.serialize,
    object.events,
  );
  writer.writeStringList(offsets[2], object.missingFields);
  writer.writeLong(offsets[3], object.sessionId);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

DecisionDraft _decisionDraftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DecisionDraft();
  object.dataJson = reader.readStringOrNull(offsets[0]);
  object.events = reader.readObjectList<DecisionEvent>(
        offsets[1],
        DecisionEventSchema.deserialize,
        allOffsets,
        DecisionEvent(),
      ) ??
      [];
  object.id = id;
  object.missingFields = reader.readStringList(offsets[2]) ?? [];
  object.sessionId = reader.readLongOrNull(offsets[3]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _decisionDraftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readObjectList<DecisionEvent>(
            offset,
            DecisionEventSchema.deserialize,
            allOffsets,
            DecisionEvent(),
          ) ??
          []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _decisionDraftGetId(DecisionDraft object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _decisionDraftGetLinks(DecisionDraft object) {
  return [];
}

void _decisionDraftAttach(
    IsarCollection<dynamic> col, Id id, DecisionDraft object) {
  object.id = id;
}

extension DecisionDraftByIndex on IsarCollection<DecisionDraft> {
  Future<DecisionDraft?> getBySessionId(int? sessionId) {
    return getByIndex(r'sessionId', [sessionId]);
  }

  DecisionDraft? getBySessionIdSync(int? sessionId) {
    return getByIndexSync(r'sessionId', [sessionId]);
  }

  Future<bool> deleteBySessionId(int? sessionId) {
    return deleteByIndex(r'sessionId', [sessionId]);
  }

  bool deleteBySessionIdSync(int? sessionId) {
    return deleteByIndexSync(r'sessionId', [sessionId]);
  }

  Future<List<DecisionDraft?>> getAllBySessionId(List<int?> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sessionId', values);
  }

  List<DecisionDraft?> getAllBySessionIdSync(List<int?> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sessionId', values);
  }

  Future<int> deleteAllBySessionId(List<int?> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sessionId', values);
  }

  int deleteAllBySessionIdSync(List<int?> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sessionId', values);
  }

  Future<Id> putBySessionId(DecisionDraft object) {
    return putByIndex(r'sessionId', object);
  }

  Id putBySessionIdSync(DecisionDraft object, {bool saveLinks = true}) {
    return putByIndexSync(r'sessionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySessionId(List<DecisionDraft> objects) {
    return putAllByIndex(r'sessionId', objects);
  }

  List<Id> putAllBySessionIdSync(List<DecisionDraft> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sessionId', objects, saveLinks: saveLinks);
  }
}

extension DecisionDraftQueryWhereSort
    on QueryBuilder<DecisionDraft, DecisionDraft, QWhere> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhere> anySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sessionId'),
      );
    });
  }
}

extension DecisionDraftQueryWhere
    on QueryBuilder<DecisionDraft, DecisionDraft, QWhereClause> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause> idBetween(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [null],
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdEqualTo(int? sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdNotEqualTo(int? sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdGreaterThan(
    int? sessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [sessionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdLessThan(
    int? sessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [],
        upper: [sessionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterWhereClause>
      sessionIdBetween(
    int? lowerSessionId,
    int? upperSessionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [lowerSessionId],
        includeLower: includeLower,
        upper: [upperSessionId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DecisionDraftQueryFilter
    on QueryBuilder<DecisionDraft, DecisionDraft, QFilterCondition> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataJson',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataJson',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      dataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsLengthEqualTo(int length) {
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsIsEmpty() {
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsIsNotEmpty() {
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsLengthLessThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsLengthGreaterThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsLengthBetween(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missingFields',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missingFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missingFields',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missingFields',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missingFields',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      missingFieldsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missingFields',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdGreaterThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdLessThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      sessionIdBetween(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      updatedAtBetween(
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

extension DecisionDraftQueryObject
    on QueryBuilder<DecisionDraft, DecisionDraft, QFilterCondition> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterFilterCondition>
      eventsElement(FilterQuery<DecisionEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'events');
    });
  }
}

extension DecisionDraftQueryLinks
    on QueryBuilder<DecisionDraft, DecisionDraft, QFilterCondition> {}

extension DecisionDraftQuerySortBy
    on QueryBuilder<DecisionDraft, DecisionDraft, QSortBy> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> sortByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      sortByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DecisionDraftQuerySortThenBy
    on QueryBuilder<DecisionDraft, DecisionDraft, QSortThenBy> {
  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> thenByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      thenByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DecisionDraftQueryWhereDistinct
    on QueryBuilder<DecisionDraft, DecisionDraft, QDistinct> {
  QueryBuilder<DecisionDraft, DecisionDraft, QDistinct> distinctByDataJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QDistinct>
      distinctByMissingFields() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missingFields');
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QDistinct> distinctBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId');
    });
  }

  QueryBuilder<DecisionDraft, DecisionDraft, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DecisionDraftQueryProperty
    on QueryBuilder<DecisionDraft, DecisionDraft, QQueryProperty> {
  QueryBuilder<DecisionDraft, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DecisionDraft, String?, QQueryOperations> dataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataJson');
    });
  }

  QueryBuilder<DecisionDraft, List<DecisionEvent>, QQueryOperations>
      eventsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'events');
    });
  }

  QueryBuilder<DecisionDraft, List<String>, QQueryOperations>
      missingFieldsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missingFields');
    });
  }

  QueryBuilder<DecisionDraft, int?, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<DecisionDraft, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
