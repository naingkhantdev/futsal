// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stadium_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StadiumVO {
  String get id => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get township => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<Facility> get facilities => throw _privateConstructorUsedError;
  int get openMinute => throw _privateConstructorUsedError;
  int get closeMinute => throw _privateConstructorUsedError;
  String get timeZone => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;

  /// Int MMK; `null` when the stadium has no active priced court.
  int? get minHourlyPrice => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StadiumVOCopyWith<StadiumVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StadiumVOCopyWith<$Res> {
  factory $StadiumVOCopyWith(StadiumVO value, $Res Function(StadiumVO) then) =
      _$StadiumVOCopyWithImpl<$Res, StadiumVO>;
  @useResult
  $Res call(
      {String id,
      String shopId,
      String name,
      String? description,
      String? address,
      String? township,
      String? city,
      double? latitude,
      double? longitude,
      List<String> images,
      List<Facility> facilities,
      int openMinute,
      int closeMinute,
      String timeZone,
      bool isActive,
      bool isPublished,
      int? minHourlyPrice,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$StadiumVOCopyWithImpl<$Res, $Val extends StadiumVO>
    implements $StadiumVOCopyWith<$Res> {
  _$StadiumVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? township = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? images = null,
    Object? facilities = null,
    Object? openMinute = null,
    Object? closeMinute = null,
    Object? timeZone = null,
    Object? isActive = null,
    Object? isPublished = null,
    Object? minHourlyPrice = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      township: freezed == township
          ? _value.township
          : township // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      facilities: null == facilities
          ? _value.facilities
          : facilities // ignore: cast_nullable_to_non_nullable
              as List<Facility>,
      openMinute: null == openMinute
          ? _value.openMinute
          : openMinute // ignore: cast_nullable_to_non_nullable
              as int,
      closeMinute: null == closeMinute
          ? _value.closeMinute
          : closeMinute // ignore: cast_nullable_to_non_nullable
              as int,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      minHourlyPrice: freezed == minHourlyPrice
          ? _value.minHourlyPrice
          : minHourlyPrice // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$StadiumVOImplCopyWith<$Res>
    implements $StadiumVOCopyWith<$Res> {
  factory _$$StadiumVOImplCopyWith(
          _$StadiumVOImpl value, $Res Function(_$StadiumVOImpl) then) =
      __$$StadiumVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shopId,
      String name,
      String? description,
      String? address,
      String? township,
      String? city,
      double? latitude,
      double? longitude,
      List<String> images,
      List<Facility> facilities,
      int openMinute,
      int closeMinute,
      String timeZone,
      bool isActive,
      bool isPublished,
      int? minHourlyPrice,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$StadiumVOImplCopyWithImpl<$Res>
    extends _$StadiumVOCopyWithImpl<$Res, _$StadiumVOImpl>
    implements _$$StadiumVOImplCopyWith<$Res> {
  __$$StadiumVOImplCopyWithImpl(
      _$StadiumVOImpl _value, $Res Function(_$StadiumVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? township = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? images = null,
    Object? facilities = null,
    Object? openMinute = null,
    Object? closeMinute = null,
    Object? timeZone = null,
    Object? isActive = null,
    Object? isPublished = null,
    Object? minHourlyPrice = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StadiumVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      township: freezed == township
          ? _value.township
          : township // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      facilities: null == facilities
          ? _value._facilities
          : facilities // ignore: cast_nullable_to_non_nullable
              as List<Facility>,
      openMinute: null == openMinute
          ? _value.openMinute
          : openMinute // ignore: cast_nullable_to_non_nullable
              as int,
      closeMinute: null == closeMinute
          ? _value.closeMinute
          : closeMinute // ignore: cast_nullable_to_non_nullable
              as int,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      minHourlyPrice: freezed == minHourlyPrice
          ? _value.minHourlyPrice
          : minHourlyPrice // ignore: cast_nullable_to_non_nullable
              as int?,
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

class _$StadiumVOImpl extends _StadiumVO {
  const _$StadiumVOImpl(
      {required this.id,
      required this.shopId,
      required this.name,
      this.description,
      this.address,
      this.township,
      this.city,
      this.latitude,
      this.longitude,
      final List<String> images = const <String>[],
      final List<Facility> facilities = const <Facility>[],
      required this.openMinute,
      required this.closeMinute,
      required this.timeZone,
      required this.isActive,
      required this.isPublished,
      this.minHourlyPrice,
      this.createdAt,
      this.updatedAt})
      : _images = images,
        _facilities = facilities,
        super._();

  @override
  final String id;
  @override
  final String shopId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String? township;
  @override
  final String? city;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<Facility> _facilities;
  @override
  @JsonKey()
  List<Facility> get facilities {
    if (_facilities is EqualUnmodifiableListView) return _facilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facilities);
  }

  @override
  final int openMinute;
  @override
  final int closeMinute;
  @override
  final String timeZone;
  @override
  final bool isActive;
  @override
  final bool isPublished;

  /// Int MMK; `null` when the stadium has no active priced court.
  @override
  final int? minHourlyPrice;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StadiumVO(id: $id, shopId: $shopId, name: $name, description: $description, address: $address, township: $township, city: $city, latitude: $latitude, longitude: $longitude, images: $images, facilities: $facilities, openMinute: $openMinute, closeMinute: $closeMinute, timeZone: $timeZone, isActive: $isActive, isPublished: $isPublished, minHourlyPrice: $minHourlyPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StadiumVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.township, township) ||
                other.township == township) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._facilities, _facilities) &&
            (identical(other.openMinute, openMinute) ||
                other.openMinute == openMinute) &&
            (identical(other.closeMinute, closeMinute) ||
                other.closeMinute == closeMinute) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.minHourlyPrice, minHourlyPrice) ||
                other.minHourlyPrice == minHourlyPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        shopId,
        name,
        description,
        address,
        township,
        city,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_facilities),
        openMinute,
        closeMinute,
        timeZone,
        isActive,
        isPublished,
        minHourlyPrice,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StadiumVOImplCopyWith<_$StadiumVOImpl> get copyWith =>
      __$$StadiumVOImplCopyWithImpl<_$StadiumVOImpl>(this, _$identity);
}

abstract class _StadiumVO extends StadiumVO {
  const factory _StadiumVO(
      {required final String id,
      required final String shopId,
      required final String name,
      final String? description,
      final String? address,
      final String? township,
      final String? city,
      final double? latitude,
      final double? longitude,
      final List<String> images,
      final List<Facility> facilities,
      required final int openMinute,
      required final int closeMinute,
      required final String timeZone,
      required final bool isActive,
      required final bool isPublished,
      final int? minHourlyPrice,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$StadiumVOImpl;
  const _StadiumVO._() : super._();

  @override
  String get id;
  @override
  String get shopId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String? get township;
  @override
  String? get city;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<String> get images;
  @override
  List<Facility> get facilities;
  @override
  int get openMinute;
  @override
  int get closeMinute;
  @override
  String get timeZone;
  @override
  bool get isActive;
  @override
  bool get isPublished;
  @override

  /// Int MMK; `null` when the stadium has no active priced court.
  int? get minHourlyPrice;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$StadiumVOImplCopyWith<_$StadiumVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
