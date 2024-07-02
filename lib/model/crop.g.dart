// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCropCollection on Isar {
  IsarCollection<Crop> get crops => this.collection();
}

const CropSchema = CollectionSchema(
  name: r'Crop',
  id: 4741289162411298676,
  properties: {
    r'cropName': PropertySchema(
      id: 0,
      name: r'cropName',
      type: IsarType.string,
    ),
    r'harvestingDates': PropertySchema(
      id: 1,
      name: r'harvestingDates',
      type: IsarType.string,
    ),
    r'plantationDates': PropertySchema(
      id: 2,
      name: r'plantationDates',
      type: IsarType.string,
    ),
    r'transplantingDates': PropertySchema(
      id: 3,
      name: r'transplantingDates',
      type: IsarType.string,
    )
  },
  estimateSize: _cropEstimateSize,
  serialize: _cropSerialize,
  deserialize: _cropDeserialize,
  deserializeProp: _cropDeserializeProp,
  idName: r'id',
  indexes: {
    r'cropName': IndexSchema(
      id: -4185822746128558756,
      name: r'cropName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cropName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cropGetId,
  getLinks: _cropGetLinks,
  attach: _cropAttach,
  version: '3.1.0+1',
);

int _cropEstimateSize(
  Crop object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cropName.length * 3;
  bytesCount += 3 + object.harvestingDates.length * 3;
  bytesCount += 3 + object.plantationDates.length * 3;
  bytesCount += 3 + object.transplantingDates.length * 3;
  return bytesCount;
}

void _cropSerialize(
  Crop object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cropName);
  writer.writeString(offsets[1], object.harvestingDates);
  writer.writeString(offsets[2], object.plantationDates);
  writer.writeString(offsets[3], object.transplantingDates);
}

Crop _cropDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Crop(
    cropName: reader.readString(offsets[0]),
    harvestingDates: reader.readString(offsets[1]),
    plantationDates: reader.readString(offsets[2]),
    transplantingDates: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _cropDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cropGetId(Crop object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cropGetLinks(Crop object) {
  return [];
}

void _cropAttach(IsarCollection<dynamic> col, Id id, Crop object) {
  object.id = id;
}

extension CropByIndex on IsarCollection<Crop> {
  Future<Crop?> getByCropName(String cropName) {
    return getByIndex(r'cropName', [cropName]);
  }

  Crop? getByCropNameSync(String cropName) {
    return getByIndexSync(r'cropName', [cropName]);
  }

  Future<bool> deleteByCropName(String cropName) {
    return deleteByIndex(r'cropName', [cropName]);
  }

  bool deleteByCropNameSync(String cropName) {
    return deleteByIndexSync(r'cropName', [cropName]);
  }

  Future<List<Crop?>> getAllByCropName(List<String> cropNameValues) {
    final values = cropNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'cropName', values);
  }

  List<Crop?> getAllByCropNameSync(List<String> cropNameValues) {
    final values = cropNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cropName', values);
  }

  Future<int> deleteAllByCropName(List<String> cropNameValues) {
    final values = cropNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cropName', values);
  }

  int deleteAllByCropNameSync(List<String> cropNameValues) {
    final values = cropNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cropName', values);
  }

  Future<Id> putByCropName(Crop object) {
    return putByIndex(r'cropName', object);
  }

  Id putByCropNameSync(Crop object, {bool saveLinks = true}) {
    return putByIndexSync(r'cropName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCropName(List<Crop> objects) {
    return putAllByIndex(r'cropName', objects);
  }

  List<Id> putAllByCropNameSync(List<Crop> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'cropName', objects, saveLinks: saveLinks);
  }
}

extension CropQueryWhereSort on QueryBuilder<Crop, Crop, QWhere> {
  QueryBuilder<Crop, Crop, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CropQueryWhere on QueryBuilder<Crop, Crop, QWhereClause> {
  QueryBuilder<Crop, Crop, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Crop, Crop, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Crop, Crop, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Crop, Crop, QAfterWhereClause> idBetween(
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

  QueryBuilder<Crop, Crop, QAfterWhereClause> cropNameEqualTo(String cropName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cropName',
        value: [cropName],
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterWhereClause> cropNameNotEqualTo(
      String cropName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cropName',
              lower: [],
              upper: [cropName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cropName',
              lower: [cropName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cropName',
              lower: [cropName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cropName',
              lower: [],
              upper: [cropName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CropQueryFilter on QueryBuilder<Crop, Crop, QFilterCondition> {
  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cropName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cropName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cropName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cropName',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> cropNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cropName',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'harvestingDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'harvestingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'harvestingDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'harvestingDates',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> harvestingDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'harvestingDates',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Crop, Crop, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Crop, Crop, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plantationDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plantationDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plantationDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plantationDates',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> plantationDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plantationDates',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transplantingDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transplantingDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transplantingDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition> transplantingDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transplantingDates',
        value: '',
      ));
    });
  }

  QueryBuilder<Crop, Crop, QAfterFilterCondition>
      transplantingDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transplantingDates',
        value: '',
      ));
    });
  }
}

extension CropQueryObject on QueryBuilder<Crop, Crop, QFilterCondition> {}

extension CropQueryLinks on QueryBuilder<Crop, Crop, QFilterCondition> {}

extension CropQuerySortBy on QueryBuilder<Crop, Crop, QSortBy> {
  QueryBuilder<Crop, Crop, QAfterSortBy> sortByCropName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropName', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByCropNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropName', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByHarvestingDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'harvestingDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByHarvestingDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'harvestingDates', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByPlantationDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantationDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByPlantationDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantationDates', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByTransplantingDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transplantingDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> sortByTransplantingDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transplantingDates', Sort.desc);
    });
  }
}

extension CropQuerySortThenBy on QueryBuilder<Crop, Crop, QSortThenBy> {
  QueryBuilder<Crop, Crop, QAfterSortBy> thenByCropName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropName', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByCropNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropName', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByHarvestingDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'harvestingDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByHarvestingDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'harvestingDates', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByPlantationDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantationDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByPlantationDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantationDates', Sort.desc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByTransplantingDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transplantingDates', Sort.asc);
    });
  }

  QueryBuilder<Crop, Crop, QAfterSortBy> thenByTransplantingDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transplantingDates', Sort.desc);
    });
  }
}

extension CropQueryWhereDistinct on QueryBuilder<Crop, Crop, QDistinct> {
  QueryBuilder<Crop, Crop, QDistinct> distinctByCropName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cropName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Crop, Crop, QDistinct> distinctByHarvestingDates(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'harvestingDates',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Crop, Crop, QDistinct> distinctByPlantationDates(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plantationDates',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Crop, Crop, QDistinct> distinctByTransplantingDates(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transplantingDates',
          caseSensitive: caseSensitive);
    });
  }
}

extension CropQueryProperty on QueryBuilder<Crop, Crop, QQueryProperty> {
  QueryBuilder<Crop, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Crop, String, QQueryOperations> cropNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cropName');
    });
  }

  QueryBuilder<Crop, String, QQueryOperations> harvestingDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'harvestingDates');
    });
  }

  QueryBuilder<Crop, String, QQueryOperations> plantationDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plantationDates');
    });
  }

  QueryBuilder<Crop, String, QQueryOperations> transplantingDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transplantingDates');
    });
  }
}
