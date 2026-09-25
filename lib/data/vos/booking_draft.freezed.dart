// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookingDraft {
  StadiumVO get stadium => throw _privateConstructorUsedError;
  CourtVO get court => throw _privateConstructorUsedError;

  /// `yyyy-MM-dd`, stadium local.
  String get date => throw _privateConstructorUsedError;
  int get startMinute => throw _privateConstructorUsedError;
  int get endMinute => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookingDraftCopyWith<BookingDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDraftCopyWith<$Res> {
  factory $BookingDraftCopyWith(
          BookingDraft value, $Res Function(BookingDraft) then) =
      _$BookingDraftCopyWithImpl<$Res, BookingDraft>;
  @useResult
  $Res call(
      {StadiumVO stadium,
      CourtVO court,
      String date,
      int startMinute,
      int endMinute});

  $StadiumVOCopyWith<$Res> get stadium;
  $CourtVOCopyWith<$Res> get court;
}

/// @nodoc
class _$BookingDraftCopyWithImpl<$Res, $Val extends BookingDraft>
    implements $BookingDraftCopyWith<$Res> {
  _$BookingDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stadium = null,
    Object? court = null,
    Object? date = null,
    Object? startMinute = null,
    Object? endMinute = null,
  }) {
    return _then(_value.copyWith(
      stadium: null == stadium
          ? _value.stadium
          : stadium // ignore: cast_nullable_to_non_nullable
              as StadiumVO,
      court: null == court
          ? _value.court
          : court // ignore: cast_nullable_to_non_nullable
              as CourtVO,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StadiumVOCopyWith<$Res> get stadium {
    return $StadiumVOCopyWith<$Res>(_value.stadium, (value) {
      return _then(_value.copyWith(stadium: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CourtVOCopyWith<$Res> get court {
    return $CourtVOCopyWith<$Res>(_value.court, (value) {
      return _then(_value.copyWith(court: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingDraftImplCopyWith<$Res>
    implements $BookingDraftCopyWith<$Res> {
  factory _$$BookingDraftImplCopyWith(
          _$BookingDraftImpl value, $Res Function(_$BookingDraftImpl) then) =
      __$$BookingDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StadiumVO stadium,
      CourtVO court,
      String date,
      int startMinute,
      int endMinute});

  @override
  $StadiumVOCopyWith<$Res> get stadium;
  @override
  $CourtVOCopyWith<$Res> get court;
}

/// @nodoc
class __$$BookingDraftImplCopyWithImpl<$Res>
    extends _$BookingDraftCopyWithImpl<$Res, _$BookingDraftImpl>
    implements _$$BookingDraftImplCopyWith<$Res> {
  __$$BookingDraftImplCopyWithImpl(
      _$BookingDraftImpl _value, $Res Function(_$BookingDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stadium = null,
    Object? court = null,
    Object? date = null,
    Object? startMinute = null,
    Object? endMinute = null,
  }) {
    return _then(_$BookingDraftImpl(
      stadium: null == stadium
          ? _value.stadium
          : stadium // ignore: cast_nullable_to_non_nullable
              as StadiumVO,
      court: null == court
          ? _value.court
          : court // ignore: cast_nullable_to_non_nullable
              as CourtVO,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      startMinute: null == startMinute
          ? _value.startMinute
          : startMinute // ignore: cast_nullable_to_non_nullable
              as int,
      endMinute: null == endMinute
          ? _value.endMinute
          : endMinute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BookingDraftImpl extends _BookingDraft {
  const _$BookingDraftImpl(
      {required this.stadium,
      required this.court,
      required this.date,
      required this.startMinute,
      required this.endMinute})
      : super._();

  @override
  final StadiumVO stadium;
  @override
  final CourtVO court;

  /// `yyyy-MM-dd`, stadium local.
  @override
  final String date;
  @override
  final int startMinute;
  @override
  final int endMinute;

  @override
  String toString() {
    return 'BookingDraft(stadium: $stadium, court: $court, date: $date, startMinute: $startMinute, endMinute: $endMinute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDraftImpl &&
            (identical(other.stadium, stadium) || other.stadium == stadium) &&
            (identical(other.court, court) || other.court == court) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startMinute, startMinute) ||
                other.startMinute == startMinute) &&
            (identical(other.endMinute, endMinute) ||
                other.endMinute == endMinute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, stadium, court, date, startMinute, endMinute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDraftImplCopyWith<_$BookingDraftImpl> get copyWith =>
      __$$BookingDraftImplCopyWithImpl<_$BookingDraftImpl>(this, _$identity);
}

abstract class _BookingDraft extends BookingDraft {
  const factory _BookingDraft(
      {required final StadiumVO stadium,
      required final CourtVO court,
      required final String date,
      required final int startMinute,
      required final int endMinute}) = _$BookingDraftImpl;
  const _BookingDraft._() : super._();

  @override
  StadiumVO get stadium;
  @override
  CourtVO get court;
  @override

  /// `yyyy-MM-dd`, stadium local.
  String get date;
  @override
  int get startMinute;
  @override
  int get endMinute;
  @override
  @JsonKey(ignore: true)
  _$$BookingDraftImplCopyWith<_$BookingDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
