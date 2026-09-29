// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blacklist_entry_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlacklistEntryVO {
  String get customerId => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  BlacklistReason get reason => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlacklistEntryVOCopyWith<BlacklistEntryVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlacklistEntryVOCopyWith<$Res> {
  factory $BlacklistEntryVOCopyWith(
          BlacklistEntryVO value, $Res Function(BlacklistEntryVO) then) =
      _$BlacklistEntryVOCopyWithImpl<$Res, BlacklistEntryVO>;
  @useResult
  $Res call(
      {String customerId,
      String shopId,
      String customerName,
      String? customerPhone,
      BlacklistReason reason,
      String? note,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class _$BlacklistEntryVOCopyWithImpl<$Res, $Val extends BlacklistEntryVO>
    implements $BlacklistEntryVOCopyWith<$Res> {
  _$BlacklistEntryVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? shopId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? reason = null,
    Object? note = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as BlacklistReason,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlacklistEntryVOImplCopyWith<$Res>
    implements $BlacklistEntryVOCopyWith<$Res> {
  factory _$$BlacklistEntryVOImplCopyWith(_$BlacklistEntryVOImpl value,
          $Res Function(_$BlacklistEntryVOImpl) then) =
      __$$BlacklistEntryVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String customerId,
      String shopId,
      String customerName,
      String? customerPhone,
      BlacklistReason reason,
      String? note,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class __$$BlacklistEntryVOImplCopyWithImpl<$Res>
    extends _$BlacklistEntryVOCopyWithImpl<$Res, _$BlacklistEntryVOImpl>
    implements _$$BlacklistEntryVOImplCopyWith<$Res> {
  __$$BlacklistEntryVOImplCopyWithImpl(_$BlacklistEntryVOImpl _value,
      $Res Function(_$BlacklistEntryVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? shopId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? reason = null,
    Object? note = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$BlacklistEntryVOImpl(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as BlacklistReason,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BlacklistEntryVOImpl implements _BlacklistEntryVO {
  const _$BlacklistEntryVOImpl(
      {required this.customerId,
      required this.shopId,
      required this.customerName,
      this.customerPhone,
      required this.reason,
      this.note,
      this.createdBy,
      this.createdAt});

  @override
  final String customerId;
  @override
  final String shopId;
  @override
  final String customerName;
  @override
  final String? customerPhone;
  @override
  final BlacklistReason reason;
  @override
  final String? note;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BlacklistEntryVO(customerId: $customerId, shopId: $shopId, customerName: $customerName, customerPhone: $customerPhone, reason: $reason, note: $note, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlacklistEntryVOImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, customerId, shopId, customerName,
      customerPhone, reason, note, createdBy, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlacklistEntryVOImplCopyWith<_$BlacklistEntryVOImpl> get copyWith =>
      __$$BlacklistEntryVOImplCopyWithImpl<_$BlacklistEntryVOImpl>(
          this, _$identity);
}

abstract class _BlacklistEntryVO implements BlacklistEntryVO {
  const factory _BlacklistEntryVO(
      {required final String customerId,
      required final String shopId,
      required final String customerName,
      final String? customerPhone,
      required final BlacklistReason reason,
      final String? note,
      final String? createdBy,
      final DateTime? createdAt}) = _$BlacklistEntryVOImpl;

  @override
  String get customerId;
  @override
  String get shopId;
  @override
  String get customerName;
  @override
  String? get customerPhone;
  @override
  BlacklistReason get reason;
  @override
  String? get note;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BlacklistEntryVOImplCopyWith<_$BlacklistEntryVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
