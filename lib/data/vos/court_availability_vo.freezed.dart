// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'court_availability_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BusySlotVO {
  /// Slot lock doc id (`SlotKey.of(date, startMinute)`).
  String get slotId => throw _privateConstructorUsedError;
  int get startMinute => throw _privateConstructorUsedError;
  int get endMinute => throw _privateConstructorUsedError;
  BusyKind get kind => throw _privateConstructorUsedError;

  /// Booking id or blocked-slot id.
  String? get refId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BusySlotVOCopyWith<BusySlotVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusySlotVOCopyWith<$Res> {
  factory $BusySlotVOCopyWith(
          BusySlotVO value, $Res Function(BusySlotVO) then) =
      _$BusySlotVOCopyWithImpl<$Res, BusySlotVO>;
  @useResult
  $Res call(
      {String slotId,
      int startMinute,
      int endMinute,
      BusyKind kind,
      String? refId});
}

/// @nodoc
class _$BusySlotVOCopyWithImpl<$Res, $Val extends BusySlotVO>
    implements $BusySlotVOCopyWith<$Res> {
  _$BusySlotVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotId = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? kind = null,
    Object? refId = freezed,
  }) {
    return _then(_value.copyWith(
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BusyKind,
      refId: freezed == refId
          ? _value.refId
          : refId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusySlotVOImplCopyWith<$Res>
    implements $BusySlotVOCopyWith<$Res> {
  factory _$$BusySlotVOImplCopyWith(
          _$BusySlotVOImpl value, $Res Function(_$BusySlotVOImpl) then) =
      __$$BusySlotVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slotId,
      int startMinute,
      int endMinute,
      BusyKind kind,
      String? refId});
}

/// @nodoc
class __$$BusySlotVOImplCopyWithImpl<$Res>
    extends _$BusySlotVOCopyWithImpl<$Res, _$BusySlotVOImpl>
    implements _$$BusySlotVOImplCopyWith<$Res> {
  __$$BusySlotVOImplCopyWithImpl(
      _$BusySlotVOImpl _value, $Res Function(_$BusySlotVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotId = null,
    Object? startMinute = null,
    Object? endMinute = null,
    Object? kind = null,
    Object? refId = freezed,
  }) {
    return _then(_$BusySlotVOImpl(
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BusyKind,
      refId: freezed == refId
          ? _value.refId
          : refId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BusySlotVOImpl extends _BusySlotVO {
  const _$BusySlotVOImpl(
      {required this.slotId,
      required this.startMinute,
      required this.endMinute,
      required this.kind,
      this.refId})
      : super._();

  /// Slot lock doc id (`SlotKey.of(date, startMinute)`).
  @override
  final String slotId;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final BusyKind kind;

  /// Booking id or blocked-slot id.
  @override
  final String? refId;

  @override
  String toString() {
    return 'BusySlotVO(slotId: $slotId, startMinute: $startMinute, endMinute: $endMinute, kind: $kind, refId: $refId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusySlotVOImpl &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.startMinute, startMinute) ||
                other.startMinute == startMinute) &&
            (identical(other.endMinute, endMinute) ||
                other.endMinute == endMinute) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.refId, refId) || other.refId == refId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, slotId, startMinute, endMinute, kind, refId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusySlotVOImplCopyWith<_$BusySlotVOImpl> get copyWith =>
      __$$BusySlotVOImplCopyWithImpl<_$BusySlotVOImpl>(this, _$identity);
}

abstract class _BusySlotVO extends BusySlotVO {
  const factory _BusySlotVO(
      {required final String slotId,
      required final int startMinute,
      required final int endMinute,
      required final BusyKind kind,
      final String? refId}) = _$BusySlotVOImpl;
  const _BusySlotVO._() : super._();

  @override

  /// Slot lock doc id (`SlotKey.of(date, startMinute)`).
  String get slotId;
  @override
  int get startMinute;
  @override
  int get endMinute;
  @override
  BusyKind get kind;
  @override

  /// Booking id or blocked-slot id.
  String? get refId;
  @override
  @JsonKey(ignore: true)
  _$$BusySlotVOImplCopyWith<_$BusySlotVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CourtAvailabilityVO {
  String get stadiumId => throw _privateConstructorUsedError;
  String get courtId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;

  /// Sorted by start minute.
  List<BusySlotVO> get busy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CourtAvailabilityVOCopyWith<CourtAvailabilityVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtAvailabilityVOCopyWith<$Res> {
  factory $CourtAvailabilityVOCopyWith(
          CourtAvailabilityVO value, $Res Function(CourtAvailabilityVO) then) =
      _$CourtAvailabilityVOCopyWithImpl<$Res, CourtAvailabilityVO>;
  @useResult
  $Res call(
      {String stadiumId, String courtId, String date, List<BusySlotVO> busy});
}

/// @nodoc
class _$CourtAvailabilityVOCopyWithImpl<$Res, $Val extends CourtAvailabilityVO>
    implements $CourtAvailabilityVOCopyWith<$Res> {
  _$CourtAvailabilityVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stadiumId = null,
    Object? courtId = null,
    Object? date = null,
    Object? busy = null,
  }) {
    return _then(_value.copyWith(
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      busy: null == busy
          ? _value.busy
          : busy // ignore: cast_nullable_to_non_nullable
              as List<BusySlotVO>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourtAvailabilityVOImplCopyWith<$Res>
    implements $CourtAvailabilityVOCopyWith<$Res> {
  factory _$$CourtAvailabilityVOImplCopyWith(_$CourtAvailabilityVOImpl value,
          $Res Function(_$CourtAvailabilityVOImpl) then) =
      __$$CourtAvailabilityVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String stadiumId, String courtId, String date, List<BusySlotVO> busy});
}

/// @nodoc
class __$$CourtAvailabilityVOImplCopyWithImpl<$Res>
    extends _$CourtAvailabilityVOCopyWithImpl<$Res, _$CourtAvailabilityVOImpl>
    implements _$$CourtAvailabilityVOImplCopyWith<$Res> {
  __$$CourtAvailabilityVOImplCopyWithImpl(_$CourtAvailabilityVOImpl _value,
      $Res Function(_$CourtAvailabilityVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stadiumId = null,
    Object? courtId = null,
    Object? date = null,
    Object? busy = null,
  }) {
    return _then(_$CourtAvailabilityVOImpl(
      stadiumId: null == stadiumId
          ? _value.stadiumId
          : stadiumId // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      busy: null == busy
          ? _value._busy
          : busy // ignore: cast_nullable_to_non_nullable
              as List<BusySlotVO>,
    ));
  }
}

/// @nodoc

class _$CourtAvailabilityVOImpl extends _CourtAvailabilityVO {
  const _$CourtAvailabilityVOImpl(
      {required this.stadiumId,
      required this.courtId,
      required this.date,
      final List<BusySlotVO> busy = const <BusySlotVO>[]})
      : _busy = busy,
        super._();

  @override
  final String stadiumId;
  @override
  final String courtId;
  @override
  final String date;

  /// Sorted by start minute.
  final List<BusySlotVO> _busy;

  /// Sorted by start minute.
  @override
  @JsonKey()
  List<BusySlotVO> get busy {
    if (_busy is EqualUnmodifiableListView) return _busy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_busy);
  }

  @override
  String toString() {
    return 'CourtAvailabilityVO(stadiumId: $stadiumId, courtId: $courtId, date: $date, busy: $busy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtAvailabilityVOImpl &&
            (identical(other.stadiumId, stadiumId) ||
                other.stadiumId == stadiumId) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._busy, _busy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stadiumId, courtId, date,
      const DeepCollectionEquality().hash(_busy));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtAvailabilityVOImplCopyWith<_$CourtAvailabilityVOImpl> get copyWith =>
      __$$CourtAvailabilityVOImplCopyWithImpl<_$CourtAvailabilityVOImpl>(
          this, _$identity);
}

abstract class _CourtAvailabilityVO extends CourtAvailabilityVO {
  const factory _CourtAvailabilityVO(
      {required final String stadiumId,
      required final String courtId,
      required final String date,
      final List<BusySlotVO> busy}) = _$CourtAvailabilityVOImpl;
  const _CourtAvailabilityVO._() : super._();

  @override
  String get stadiumId;
  @override
  String get courtId;
  @override
  String get date;
  @override

  /// Sorted by start minute.
  List<BusySlotVO> get busy;
  @override
  @JsonKey(ignore: true)
  _$$CourtAvailabilityVOImplCopyWith<_$CourtAvailabilityVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
