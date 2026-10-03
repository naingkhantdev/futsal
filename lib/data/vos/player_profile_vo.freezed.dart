// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_profile_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerProfileVO {
  String get uid => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  PlayerPosition get position => throw _privateConstructorUsedError;
  SkillLevel get skillLevel => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerProfileVOCopyWith<PlayerProfileVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerProfileVOCopyWith<$Res> {
  factory $PlayerProfileVOCopyWith(
          PlayerProfileVO value, $Res Function(PlayerProfileVO) then) =
      _$PlayerProfileVOCopyWithImpl<$Res, PlayerProfileVO>;
  @useResult
  $Res call(
      {String uid,
      String displayName,
      PlayerPosition position,
      SkillLevel skillLevel,
      String? bio,
      DateTime? updatedAt});
}

/// @nodoc
class _$PlayerProfileVOCopyWithImpl<$Res, $Val extends PlayerProfileVO>
    implements $PlayerProfileVOCopyWith<$Res> {
  _$PlayerProfileVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? position = null,
    Object? skillLevel = null,
    Object? bio = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PlayerPosition,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerProfileVOImplCopyWith<$Res>
    implements $PlayerProfileVOCopyWith<$Res> {
  factory _$$PlayerProfileVOImplCopyWith(_$PlayerProfileVOImpl value,
          $Res Function(_$PlayerProfileVOImpl) then) =
      __$$PlayerProfileVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String displayName,
      PlayerPosition position,
      SkillLevel skillLevel,
      String? bio,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PlayerProfileVOImplCopyWithImpl<$Res>
    extends _$PlayerProfileVOCopyWithImpl<$Res, _$PlayerProfileVOImpl>
    implements _$$PlayerProfileVOImplCopyWith<$Res> {
  __$$PlayerProfileVOImplCopyWithImpl(
      _$PlayerProfileVOImpl _value, $Res Function(_$PlayerProfileVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? position = null,
    Object? skillLevel = null,
    Object? bio = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PlayerProfileVOImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PlayerPosition,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$PlayerProfileVOImpl extends _PlayerProfileVO {
  const _$PlayerProfileVOImpl(
      {required this.uid,
      required this.displayName,
      required this.position,
      required this.skillLevel,
      this.bio,
      this.updatedAt})
      : super._();

  @override
  final String uid;
  @override
  final String displayName;
  @override
  final PlayerPosition position;
  @override
  final SkillLevel skillLevel;
  @override
  final String? bio;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PlayerProfileVO(uid: $uid, displayName: $displayName, position: $position, skillLevel: $skillLevel, bio: $bio, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerProfileVOImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.skillLevel, skillLevel) ||
                other.skillLevel == skillLevel) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, uid, displayName, position, skillLevel, bio, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerProfileVOImplCopyWith<_$PlayerProfileVOImpl> get copyWith =>
      __$$PlayerProfileVOImplCopyWithImpl<_$PlayerProfileVOImpl>(
          this, _$identity);
}

abstract class _PlayerProfileVO extends PlayerProfileVO {
  const factory _PlayerProfileVO(
      {required final String uid,
      required final String displayName,
      required final PlayerPosition position,
      required final SkillLevel skillLevel,
      final String? bio,
      final DateTime? updatedAt}) = _$PlayerProfileVOImpl;
  const _PlayerProfileVO._() : super._();

  @override
  String get uid;
  @override
  String get displayName;
  @override
  PlayerPosition get position;
  @override
  SkillLevel get skillLevel;
  @override
  String? get bio;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlayerProfileVOImplCopyWith<_$PlayerProfileVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
