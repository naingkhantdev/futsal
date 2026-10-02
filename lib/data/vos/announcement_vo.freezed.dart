// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnnouncementVO {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  AnnouncementAudience get audience => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnnouncementVOCopyWith<AnnouncementVO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnnouncementVOCopyWith<$Res> {
  factory $AnnouncementVOCopyWith(
          AnnouncementVO value, $Res Function(AnnouncementVO) then) =
      _$AnnouncementVOCopyWithImpl<$Res, AnnouncementVO>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      AnnouncementAudience audience,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class _$AnnouncementVOCopyWithImpl<$Res, $Val extends AnnouncementVO>
    implements $AnnouncementVOCopyWith<$Res> {
  _$AnnouncementVOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? audience = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      audience: null == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AnnouncementAudience,
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
abstract class _$$AnnouncementVOImplCopyWith<$Res>
    implements $AnnouncementVOCopyWith<$Res> {
  factory _$$AnnouncementVOImplCopyWith(_$AnnouncementVOImpl value,
          $Res Function(_$AnnouncementVOImpl) then) =
      __$$AnnouncementVOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      AnnouncementAudience audience,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class __$$AnnouncementVOImplCopyWithImpl<$Res>
    extends _$AnnouncementVOCopyWithImpl<$Res, _$AnnouncementVOImpl>
    implements _$$AnnouncementVOImplCopyWith<$Res> {
  __$$AnnouncementVOImplCopyWithImpl(
      _$AnnouncementVOImpl _value, $Res Function(_$AnnouncementVOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? audience = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AnnouncementVOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      audience: null == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as AnnouncementAudience,
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

class _$AnnouncementVOImpl implements _AnnouncementVO {
  const _$AnnouncementVOImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.audience,
      this.createdBy,
      this.createdAt});

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final AnnouncementAudience audience;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AnnouncementVO(id: $id, title: $title, body: $body, audience: $audience, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnnouncementVOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, body, audience, createdBy, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnnouncementVOImplCopyWith<_$AnnouncementVOImpl> get copyWith =>
      __$$AnnouncementVOImplCopyWithImpl<_$AnnouncementVOImpl>(
          this, _$identity);
}

abstract class _AnnouncementVO implements AnnouncementVO {
  const factory _AnnouncementVO(
      {required final String id,
      required final String title,
      required final String body,
      required final AnnouncementAudience audience,
      final String? createdBy,
      final DateTime? createdAt}) = _$AnnouncementVOImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  AnnouncementAudience get audience;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AnnouncementVOImplCopyWith<_$AnnouncementVOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
