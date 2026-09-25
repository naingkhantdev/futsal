// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'court_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CourtVO {
  String get id => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get stadiumId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get surfaceType => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;

  /// Int MMK per hour; `null` when unset or malformed (not bookable).
  int? get hourlyPrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  int get slotMinutes => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CourtVOCopyWith<CourtVO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtVOCopyWith<$Res> {
  factory $CourtVOCopyWith(CourtVO value, $Res Function(CourtVO) then) =
      _$CourtVOCopyWithImpl<$Res, CourtVO>;
  @useResult
  $Res call(
      {String id,
      String shopId,
      String stadiumId,
      String name,
      String? description,
      String? surfaceType,
      int? capacity,
      int? hourlyPrice,
      String currency,
      int slotMinutes,
      List<String> images,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CourtVOCopyWithImpl<$Res, $Val extends CourtVO>
    implements $CourtVOCopyWith<$Res> {
  _$CourtVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? stadiumId = null,
    Object? name = null,
    Object? description = freezed,
    Object? surfaceType = freezed,
    Object? capacity = freezed,
    Object? hourlyPrice = freezed,
    Object? currency = null,
    Object? slotMinutes = null,
    Object? images = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      surfaceType: freezed == surfaceType
          ? _value.surfaceType
          : surfaceType // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      hourlyPrice: freezed == hourlyPrice
          ? _value.hourlyPrice
          : hourlyPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      slotMinutes: null == slotMinutes
          ? _value.slotMinutes
          : slotMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourtVOImplCopyWith<$Res> implements $CourtVOCopyWith<$Res> {
  factory _$$CourtVOImplCopyWith(
          _$CourtVOImpl value, $Res Function(_$CourtVOImpl) then) =
      __$$CourtVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shopId,
      String stadiumId,
      String name,
      String? description,
      String? surfaceType,
      int? capacity,
      int? hourlyPrice,
      String currency,
      int slotMinutes,
      List<String> images,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CourtVOImplCopyWithImpl<$Res>
    extends _$CourtVOCopyWithImpl<$Res, _$CourtVOImpl>
    implements _$$CourtVOImplCopyWith<$Res> {
  __$$CourtVOImplCopyWithImpl(
      _$CourtVOImpl _value, $Res Function(_$CourtVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? stadiumId = null,
    Object? name = null,
    Object? description = freezed,
    Object? surfaceType = freezed,
    Object? capacity = freezed,
    Object? hourlyPrice = freezed,
    Object? currency = null,
    Object? slotMinutes = null,
    Object? images = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CourtVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      surfaceType: freezed == surfaceType
          ? _value.surfaceType
          : surfaceType // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      hourlyPrice: freezed == hourlyPrice
          ? _value.hourlyPrice
          : hourlyPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      slotMinutes: null == slotMinutes
          ? _value.slotMinutes
          : slotMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CourtVOImpl extends _CourtVO {
  const _$CourtVOImpl(
      {required this.id,
      required this.shopId,
      required this.stadiumId,
      required this.name,
      this.description,
      this.surfaceType,
      this.capacity,
      this.hourlyPrice,
      required this.currency,
      required this.slotMinutes,
      final List<String> images = const <String>[],
      required this.isActive,
      this.createdAt,
      this.updatedAt})
      : _images = images,
        super._();

  @override
  final String id;
  @override
  final String shopId;
  @override
  final String stadiumId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? surfaceType;
  @override
  final int? capacity;

  /// Int MMK per hour; `null` when unset or malformed (not bookable).
  @override
  final int? hourlyPrice;
  @override
  final String currency;
  @override
  final int slotMinutes;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CourtVO(id: $id, shopId: $shopId, stadiumId: $stadiumId, name: $name, description: $description, surfaceType: $surfaceType, capacity: $capacity, hourlyPrice: $hourlyPrice, currency: $currency, slotMinutes: $slotMinutes, images: $images, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.stadiumId, stadiumId) ||
                other.stadiumId == stadiumId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.surfaceType, surfaceType) ||
                other.surfaceType == surfaceType) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.hourlyPrice, hourlyPrice) ||
                other.hourlyPrice == hourlyPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.slotMinutes, slotMinutes) ||
                other.slotMinutes == slotMinutes) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      stadiumId,
      name,
      description,
      surfaceType,
      capacity,
      hourlyPrice,
      currency,
      slotMinutes,
      const DeepCollectionEquality().hash(_images),
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtVOImplCopyWith<_$CourtVOImpl> get copyWith =>
      __$$CourtVOImplCopyWithImpl<_$CourtVOImpl>(this, _$identity);
}

abstract class _CourtVO extends CourtVO {
  const factory _CourtVO(
      {required final String id,
      required final String shopId,
      required final String stadiumId,
      required final String name,
      final String? description,
      final String? surfaceType,
      final int? capacity,
      final int? hourlyPrice,
      required final String currency,
      required final int slotMinutes,
      final List<String> images,
      required final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$CourtVOImpl;
  const _CourtVO._() : super._();

  @override
  String get id;
  @override
  String get shopId;
  @override
  String get stadiumId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get surfaceType;
  @override
  int? get capacity;
  @override

  /// Int MMK per hour; `null` when unset or malformed (not bookable).
  int? get hourlyPrice;
  @override
  String get currency;
  @override
  int get slotMinutes;
  @override
  List<String> get images;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CourtVOImplCopyWith<_$CourtVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
