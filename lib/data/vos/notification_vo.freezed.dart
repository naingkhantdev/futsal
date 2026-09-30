// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationVO {
  String get id => throw _privateConstructorUsedError;
  NotificationAudience get audience => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get stadiumName => throw _privateConstructorUsedError;
  String get courtName => throw _privateConstructorUsedError;
  String get bookingDate => throw _privateConstructorUsedError;
  int get startMinute => throw _privateConstructorUsedError;
  int get endMinute => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationVOCopyWith<NotificationVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationVOCopyWith<$Res> {
  factory $NotificationVOCopyWith(
          NotificationVO value, $Res Function(NotificationVO) then) =
      _$NotificationVOCopyWithImpl<$Res, NotificationVO>;
  @useResult
  $Res call(
      {String id,
      NotificationAudience audience,
      String shopId,
      String bookingId,
      NotificationType type,
      String customerName,
      String stadiumName,
      String courtName,
      String bookingDate,
      int startMinute,
      int endMinute,
      String? reason,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class _$NotificationVOCopyWithImpl<$Res, $Val extends NotificationVO>
    implements $NotificationVOCopyWith<$Res> {
  _$NotificationVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? audience = null,
    Object? shopId = null,
    Object? bookingId = null,
    Object? type = null,
    Object? customerName = null,
    Object? stadiumName = null,
    Object? courtName = null,
    Object? bookingDate = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? reason = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      audience: null == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as NotificationAudience,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumName: null == stadiumName
          ? _value.stadiumName
          : stadiumName // ignore: cast_nullable_to_non_nullable
              as String,
      courtName: null == courtName
          ? _value.courtName
          : courtName // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationVOImplCopyWith<$Res>
    implements $NotificationVOCopyWith<$Res> {
  factory _$$NotificationVOImplCopyWith(_$NotificationVOImpl value,
          $Res Function(_$NotificationVOImpl) then) =
      __$$NotificationVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      NotificationAudience audience,
      String shopId,
      String bookingId,
      NotificationType type,
      String customerName,
      String stadiumName,
      String courtName,
      String bookingDate,
      int startMinute,
      int endMinute,
      String? reason,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class __$$NotificationVOImplCopyWithImpl<$Res>
    extends _$NotificationVOCopyWithImpl<$Res, _$NotificationVOImpl>
    implements _$$NotificationVOImplCopyWith<$Res> {
  __$$NotificationVOImplCopyWithImpl(
      _$NotificationVOImpl _value, $Res Function(_$NotificationVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? audience = null,
    Object? shopId = null,
    Object? bookingId = null,
    Object? type = null,
    Object? customerName = null,
    Object? stadiumName = null,
    Object? courtName = null,
    Object? bookingDate = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? reason = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$NotificationVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      audience: null == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as NotificationAudience,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumName: null == stadiumName
          ? _value.stadiumName
          : stadiumName // ignore: cast_nullable_to_non_nullable
              as String,
      courtName: null == courtName
          ? _value.courtName
          : courtName // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$NotificationVOImpl implements _NotificationVO {
  const _$NotificationVOImpl(
      {required this.id,
      required this.audience,
      required this.shopId,
      required this.bookingId,
      required this.type,
      required this.customerName,
      required this.stadiumName,
      required this.courtName,
      required this.bookingDate,
      required this.startMinute,
      required this.endMinute,
      this.reason,
      required this.isRead,
      this.createdAt});

  @override
  final String id;
  @override
  final NotificationAudience audience;
  @override
  final String shopId;
  @override
  final String bookingId;
  @override
  final NotificationType type;
  @override
  final String customerName;
  @override
  final String stadiumName;
  @override
  final String courtName;
  @override
  final String bookingDate;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final String? reason;
  @override
  final bool isRead;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'NotificationVO(id: $id, audience: $audience, shopId: $shopId, bookingId: $bookingId, type: $type, customerName: $customerName, stadiumName: $stadiumName, courtName: $courtName, bookingDate: $bookingDate, startMinute: $startMinute, endMinute: $endMinute, reason: $reason, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.stadiumName, stadiumName) ||
                other.stadiumName == stadiumName) &&
            (identical(other.courtName, courtName) ||
                other.courtName == courtName) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startMinute, startMinute) ||
                other.startMinute == startMinute) &&
            (identical(other.endMinute, endMinute) ||
                other.endMinute == endMinute) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      audience,
      shopId,
      bookingId,
      type,
      customerName,
      stadiumName,
      courtName,
      bookingDate,
      startMinute,
      endMinute,
      reason,
      isRead,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationVOImplCopyWith<_$NotificationVOImpl> get copyWith =>
      __$$NotificationVOImplCopyWithImpl<_$NotificationVOImpl>(
          this, _$identity);
}

abstract class _NotificationVO implements NotificationVO {
  const factory _NotificationVO(
      {required final String id,
      required final NotificationAudience audience,
      required final String shopId,
      required final String bookingId,
      required final NotificationType type,
      required final String customerName,
      required final String stadiumName,
      required final String courtName,
      required final String bookingDate,
      required final int startMinute,
      required final int endMinute,
      final String? reason,
      required final bool isRead,
      final DateTime? createdAt}) = _$NotificationVOImpl;

  @override
  String get id;
  @override
  NotificationAudience get audience;
  @override
  String get shopId;
  @override
  String get bookingId;
  @override
  NotificationType get type;
  @override
  String get customerName;
  @override
  String get stadiumName;
  @override
  String get courtName;
  @override
  String get bookingDate;
  @override
  int get startMinute;
  @override
  int get endMinute;
  @override
  String? get reason;
  @override
  bool get isRead;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationVOImplCopyWith<_$NotificationVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
