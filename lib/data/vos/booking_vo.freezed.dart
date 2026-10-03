// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookingVO {
  String get id => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get stadiumId => throw _privateConstructorUsedError;
  String get courtId => throw _privateConstructorUsedError;
  String get bookingDate => throw _privateConstructorUsedError;
  int get startMinute => throw _privateConstructorUsedError;
  int get endMinute => throw _privateConstructorUsedError;

  /// Court slot length at booking time (locates the slot lock docs).
  int get slotMinutes => throw _privateConstructorUsedError;
  DateTime? get startAt => throw _privateConstructorUsedError;
  DateTime? get endAt => throw _privateConstructorUsedError;

  /// Int MMK.
  int get pricePerHour => throw _privateConstructorUsedError;
  int get totalPrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  String get customerNameSnapshot => throw _privateConstructorUsedError;
  String? get customerPhoneSnapshot => throw _privateConstructorUsedError;
  String get stadiumNameSnapshot => throw _privateConstructorUsedError;
  String get courtNameSnapshot => throw _privateConstructorUsedError;

  /// The venue's free-cancellation window when booked (`null` = none).
  int? get freeCancelHours => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingVOCopyWith<BookingVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingVOCopyWith<$Res> {
  factory $BookingVOCopyWith(BookingVO value, $Res Function(BookingVO) then) =
      _$BookingVOCopyWithImpl<$Res, BookingVO>;
  @useResult
  $Res call(
      {String id,
      String shopId,
      String customerId,
      String stadiumId,
      String courtId,
      String bookingDate,
      int startMinute,
      int endMinute,
      int slotMinutes,
      DateTime? startAt,
      DateTime? endAt,
      int pricePerHour,
      int totalPrice,
      String currency,
      BookingStatus status,
      PaymentStatus paymentStatus,
      String customerNameSnapshot,
      String? customerPhoneSnapshot,
      String stadiumNameSnapshot,
      String courtNameSnapshot,
      int? freeCancelHours,
      DateTime? cancelledAt,
      String? cancelReason,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BookingVOCopyWithImpl<$Res, $Val extends BookingVO>
    implements $BookingVOCopyWith<$Res> {
  _$BookingVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? customerId = null,
    Object? stadiumId = null,
    Object? courtId = null,
    Object? bookingDate = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? slotMinutes = null,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? pricePerHour = null,
    Object? totalPrice = null,
    Object? currency = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? customerNameSnapshot = null,
    Object? customerPhoneSnapshot = freezed,
    Object? stadiumNameSnapshot = null,
    Object? courtNameSnapshot = null,
    Object? freeCancelHours = freezed,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
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
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
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
      slotMinutes: null == slotMinutes
          ? _value.slotMinutes
          : slotMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: freezed == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      customerNameSnapshot: null == customerNameSnapshot
          ? _value.customerNameSnapshot
          : customerNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneSnapshot: freezed == customerPhoneSnapshot
          ? _value.customerPhoneSnapshot
          : customerPhoneSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      stadiumNameSnapshot: null == stadiumNameSnapshot
          ? _value.stadiumNameSnapshot
          : stadiumNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      courtNameSnapshot: null == courtNameSnapshot
          ? _value.courtNameSnapshot
          : courtNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      freeCancelHours: freezed == freeCancelHours
          ? _value.freeCancelHours
          : freeCancelHours // ignore: cast_nullable_to_non_nullable
              as int?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$BookingVOImplCopyWith<$Res>
    implements $BookingVOCopyWith<$Res> {
  factory _$$BookingVOImplCopyWith(
          _$BookingVOImpl value, $Res Function(_$BookingVOImpl) then) =
      __$$BookingVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shopId,
      String customerId,
      String stadiumId,
      String courtId,
      String bookingDate,
      int startMinute,
      int endMinute,
      int slotMinutes,
      DateTime? startAt,
      DateTime? endAt,
      int pricePerHour,
      int totalPrice,
      String currency,
      BookingStatus status,
      PaymentStatus paymentStatus,
      String customerNameSnapshot,
      String? customerPhoneSnapshot,
      String stadiumNameSnapshot,
      String courtNameSnapshot,
      int? freeCancelHours,
      DateTime? cancelledAt,
      String? cancelReason,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BookingVOImplCopyWithImpl<$Res>
    extends _$BookingVOCopyWithImpl<$Res, _$BookingVOImpl>
    implements _$$BookingVOImplCopyWith<$Res> {
  __$$BookingVOImplCopyWithImpl(
      _$BookingVOImpl _value, $Res Function(_$BookingVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? customerId = null,
    Object? stadiumId = null,
    Object? courtId = null,
    Object? bookingDate = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? slotMinutes = null,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? pricePerHour = null,
    Object? totalPrice = null,
    Object? currency = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? customerNameSnapshot = null,
    Object? customerPhoneSnapshot = freezed,
    Object? stadiumNameSnapshot = null,
    Object? courtNameSnapshot = null,
    Object? freeCancelHours = freezed,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BookingVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
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
      slotMinutes: null == slotMinutes
          ? _value.slotMinutes
          : slotMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: freezed == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      customerNameSnapshot: null == customerNameSnapshot
          ? _value.customerNameSnapshot
          : customerNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneSnapshot: freezed == customerPhoneSnapshot
          ? _value.customerPhoneSnapshot
          : customerPhoneSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      stadiumNameSnapshot: null == stadiumNameSnapshot
          ? _value.stadiumNameSnapshot
          : stadiumNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      courtNameSnapshot: null == courtNameSnapshot
          ? _value.courtNameSnapshot
          : courtNameSnapshot // ignore: cast_nullable_to_non_nullable
              as String,
      freeCancelHours: freezed == freeCancelHours
          ? _value.freeCancelHours
          : freeCancelHours // ignore: cast_nullable_to_non_nullable
              as int?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _$BookingVOImpl extends _BookingVO {
  const _$BookingVOImpl(
      {required this.id,
      required this.shopId,
      required this.customerId,
      required this.stadiumId,
      required this.courtId,
      required this.bookingDate,
      required this.startMinute,
      required this.endMinute,
      this.slotMinutes = BookingPolicy.defaultSlotMinutes,
      this.startAt,
      this.endAt,
      required this.pricePerHour,
      required this.totalPrice,
      required this.currency,
      required this.status,
      required this.paymentStatus,
      required this.customerNameSnapshot,
      this.customerPhoneSnapshot,
      required this.stadiumNameSnapshot,
      required this.courtNameSnapshot,
      this.freeCancelHours,
      this.cancelledAt,
      this.cancelReason,
      this.createdAt,
      this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final String shopId;
  @override
  final String customerId;
  @override
  final String stadiumId;
  @override
  final String courtId;
  @override
  final String bookingDate;
  @override
  final int startMinute;
  @override
  final int endMinute;

  /// Court slot length at booking time (locates the slot lock docs).
  @override
  @JsonKey()
  final int slotMinutes;
  @override
  final DateTime? startAt;
  @override
  final DateTime? endAt;

  /// Int MMK.
  @override
  final int pricePerHour;
  @override
  final int totalPrice;
  @override
  final String currency;
  @override
  final BookingStatus status;
  @override
  final PaymentStatus paymentStatus;
  @override
  final String customerNameSnapshot;
  @override
  final String? customerPhoneSnapshot;
  @override
  final String stadiumNameSnapshot;
  @override
  final String courtNameSnapshot;

  /// The venue's free-cancellation window when booked (`null` = none).
  @override
  final int? freeCancelHours;
  @override
  final DateTime? cancelledAt;
  @override
  final String? cancelReason;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingVO(id: $id, shopId: $shopId, customerId: $customerId, stadiumId: $stadiumId, courtId: $courtId, bookingDate: $bookingDate, startMinute: $startMinute, endMinute: $endMinute, slotMinutes: $slotMinutes, startAt: $startAt, endAt: $endAt, pricePerHour: $pricePerHour, totalPrice: $totalPrice, currency: $currency, status: $status, paymentStatus: $paymentStatus, customerNameSnapshot: $customerNameSnapshot, customerPhoneSnapshot: $customerPhoneSnapshot, stadiumNameSnapshot: $stadiumNameSnapshot, courtNameSnapshot: $courtNameSnapshot, freeCancelHours: $freeCancelHours, cancelledAt: $cancelledAt, cancelReason: $cancelReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.stadiumId, stadiumId) ||
                other.stadiumId == stadiumId) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startMinute, startMinute) ||
                other.startMinute == startMinute) &&
            (identical(other.endMinute, endMinute) ||
                other.endMinute == endMinute) &&
            (identical(other.slotMinutes, slotMinutes) ||
                other.slotMinutes == slotMinutes) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.customerNameSnapshot, customerNameSnapshot) ||
                other.customerNameSnapshot == customerNameSnapshot) &&
            (identical(other.customerPhoneSnapshot, customerPhoneSnapshot) ||
                other.customerPhoneSnapshot == customerPhoneSnapshot) &&
            (identical(other.stadiumNameSnapshot, stadiumNameSnapshot) ||
                other.stadiumNameSnapshot == stadiumNameSnapshot) &&
            (identical(other.courtNameSnapshot, courtNameSnapshot) ||
                other.courtNameSnapshot == courtNameSnapshot) &&
            (identical(other.freeCancelHours, freeCancelHours) ||
                other.freeCancelHours == freeCancelHours) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
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
        customerId,
        stadiumId,
        courtId,
        bookingDate,
        startMinute,
        endMinute,
        slotMinutes,
        startAt,
        endAt,
        pricePerHour,
        totalPrice,
        currency,
        status,
        paymentStatus,
        customerNameSnapshot,
        customerPhoneSnapshot,
        stadiumNameSnapshot,
        courtNameSnapshot,
        freeCancelHours,
        cancelledAt,
        cancelReason,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingVOImplCopyWith<_$BookingVOImpl> get copyWith =>
      __$$BookingVOImplCopyWithImpl<_$BookingVOImpl>(this, _$identity);
}

abstract class _BookingVO extends BookingVO {
  const factory _BookingVO(
      {required final String id,
      required final String shopId,
      required final String customerId,
      required final String stadiumId,
      required final String courtId,
      required final String bookingDate,
      required final int startMinute,
      required final int endMinute,
      final int slotMinutes,
      final DateTime? startAt,
      final DateTime? endAt,
      required final int pricePerHour,
      required final int totalPrice,
      required final String currency,
      required final BookingStatus status,
      required final PaymentStatus paymentStatus,
      required final String customerNameSnapshot,
      final String? customerPhoneSnapshot,
      required final String stadiumNameSnapshot,
      required final String courtNameSnapshot,
      final int? freeCancelHours,
      final DateTime? cancelledAt,
      final String? cancelReason,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BookingVOImpl;
  const _BookingVO._() : super._();

  @override
  String get id;
  @override
  String get shopId;
  @override
  String get customerId;
  @override
  String get stadiumId;
  @override
  String get courtId;
  @override
  String get bookingDate;
  @override
  int get startMinute;
  @override
  int get endMinute;
  @override

  /// Court slot length at booking time (locates the slot lock docs).
  int get slotMinutes;
  @override
  DateTime? get startAt;
  @override
  DateTime? get endAt;
  @override

  /// Int MMK.
  int get pricePerHour;
  @override
  int get totalPrice;
  @override
  String get currency;
  @override
  BookingStatus get status;
  @override
  PaymentStatus get paymentStatus;
  @override
  String get customerNameSnapshot;
  @override
  String? get customerPhoneSnapshot;
  @override
  String get stadiumNameSnapshot;
  @override
  String get courtNameSnapshot;
  @override

  /// The venue's free-cancellation window when booked (`null` = none).
  int? get freeCancelHours;
  @override
  DateTime? get cancelledAt;
  @override
  String? get cancelReason;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingVOImplCopyWith<_$BookingVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
