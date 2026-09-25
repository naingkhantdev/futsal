// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShopVO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  String? get coverImage => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get township => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  ShopStatus get status => throw _privateConstructorUsedError;
  bool get isListed => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShopVOCopyWith<ShopVO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopVOCopyWith<$Res> {
  factory $ShopVOCopyWith(ShopVO value, $Res Function(ShopVO) then) =
      _$ShopVOCopyWithImpl<$Res, ShopVO>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? slug,
      String? description,
      String? logo,
      String? coverImage,
      String? phone,
      String? email,
      String? address,
      String? township,
      String? city,
      double? latitude,
      double? longitude,
      ShopStatus status,
      bool isListed,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ShopVOCopyWithImpl<$Res, $Val extends ShopVO>
    implements $ShopVOCopyWith<$Res> {
  _$ShopVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? township = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? isListed = null,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShopStatus,
      isListed: null == isListed
          ? _value.isListed
          : isListed // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$ShopVOImplCopyWith<$Res> implements $ShopVOCopyWith<$Res> {
  factory _$$ShopVOImplCopyWith(
          _$ShopVOImpl value, $Res Function(_$ShopVOImpl) then) =
      __$$ShopVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? slug,
      String? description,
      String? logo,
      String? coverImage,
      String? phone,
      String? email,
      String? address,
      String? township,
      String? city,
      double? latitude,
      double? longitude,
      ShopStatus status,
      bool isListed,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ShopVOImplCopyWithImpl<$Res>
    extends _$ShopVOCopyWithImpl<$Res, _$ShopVOImpl>
    implements _$$ShopVOImplCopyWith<$Res> {
  __$$ShopVOImplCopyWithImpl(
      _$ShopVOImpl _value, $Res Function(_$ShopVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? township = freezed,
    Object? city = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? isListed = null,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ShopVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShopStatus,
      isListed: null == isListed
          ? _value.isListed
          : isListed // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

class _$ShopVOImpl extends _ShopVO {
  const _$ShopVOImpl(
      {required this.id,
      required this.name,
      this.slug,
      this.description,
      this.logo,
      this.coverImage,
      this.phone,
      this.email,
      this.address,
      this.township,
      this.city,
      this.latitude,
      this.longitude,
      required this.status,
      required this.isListed,
      this.approvedAt,
      this.createdAt,
      this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? description;
  @override
  final String? logo;
  @override
  final String? coverImage;
  @override
  final String? phone;
  @override
  final String? email;
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
  @override
  final ShopStatus status;
  @override
  final bool isListed;
  @override
  final DateTime? approvedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ShopVO(id: $id, name: $name, slug: $slug, description: $description, logo: $logo, coverImage: $coverImage, phone: $phone, email: $email, address: $address, township: $township, city: $city, latitude: $latitude, longitude: $longitude, status: $status, isListed: $isListed, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.township, township) ||
                other.township == township) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isListed, isListed) ||
                other.isListed == isListed) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      logo,
      coverImage,
      phone,
      email,
      address,
      township,
      city,
      latitude,
      longitude,
      status,
      isListed,
      approvedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopVOImplCopyWith<_$ShopVOImpl> get copyWith =>
      __$$ShopVOImplCopyWithImpl<_$ShopVOImpl>(this, _$identity);
}

abstract class _ShopVO extends ShopVO {
  const factory _ShopVO(
      {required final String id,
      required final String name,
      final String? slug,
      final String? description,
      final String? logo,
      final String? coverImage,
      final String? phone,
      final String? email,
      final String? address,
      final String? township,
      final String? city,
      final double? latitude,
      final double? longitude,
      required final ShopStatus status,
      required final bool isListed,
      final DateTime? approvedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ShopVOImpl;
  const _ShopVO._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String? get slug;
  @override
  String? get description;
  @override
  String? get logo;
  @override
  String? get coverImage;
  @override
  String? get phone;
  @override
  String? get email;
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
  ShopStatus get status;
  @override
  bool get isListed;
  @override
  DateTime? get approvedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ShopVOImplCopyWith<_$ShopVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
