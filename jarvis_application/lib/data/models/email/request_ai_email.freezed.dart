// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_ai_email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestAiEmail _$RequestAiEmailFromJson(Map<String, dynamic> json) {
  return _RequestAiEmail.fromJson(json);
}

/// @nodoc
mixin _$RequestAiEmail {
  String get mainIdea => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  AiEmailMetadata get metadata => throw _privateConstructorUsedError;

  /// Serializes this RequestAiEmail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestAiEmailCopyWith<RequestAiEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestAiEmailCopyWith<$Res> {
  factory $RequestAiEmailCopyWith(
          RequestAiEmail value, $Res Function(RequestAiEmail) then) =
      _$RequestAiEmailCopyWithImpl<$Res, RequestAiEmail>;
  @useResult
  $Res call(
      {String mainIdea, String action, String email, AiEmailMetadata metadata});

  $AiEmailMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$RequestAiEmailCopyWithImpl<$Res, $Val extends RequestAiEmail>
    implements $RequestAiEmailCopyWith<$Res> {
  _$RequestAiEmailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainIdea = null,
    Object? action = null,
    Object? email = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      mainIdea: null == mainIdea
          ? _value.mainIdea
          : mainIdea // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as AiEmailMetadata,
    ) as $Val);
  }

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiEmailMetadataCopyWith<$Res> get metadata {
    return $AiEmailMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestAiEmailImplCopyWith<$Res>
    implements $RequestAiEmailCopyWith<$Res> {
  factory _$$RequestAiEmailImplCopyWith(_$RequestAiEmailImpl value,
          $Res Function(_$RequestAiEmailImpl) then) =
      __$$RequestAiEmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mainIdea, String action, String email, AiEmailMetadata metadata});

  @override
  $AiEmailMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$RequestAiEmailImplCopyWithImpl<$Res>
    extends _$RequestAiEmailCopyWithImpl<$Res, _$RequestAiEmailImpl>
    implements _$$RequestAiEmailImplCopyWith<$Res> {
  __$$RequestAiEmailImplCopyWithImpl(
      _$RequestAiEmailImpl _value, $Res Function(_$RequestAiEmailImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainIdea = null,
    Object? action = null,
    Object? email = null,
    Object? metadata = null,
  }) {
    return _then(_$RequestAiEmailImpl(
      mainIdea: null == mainIdea
          ? _value.mainIdea
          : mainIdea // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as AiEmailMetadata,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestAiEmailImpl implements _RequestAiEmail {
  const _$RequestAiEmailImpl(
      {required this.mainIdea,
      required this.action,
      required this.email,
      required this.metadata});

  factory _$RequestAiEmailImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestAiEmailImplFromJson(json);

  @override
  final String mainIdea;
  @override
  final String action;
  @override
  final String email;
  @override
  final AiEmailMetadata metadata;

  @override
  String toString() {
    return 'RequestAiEmail(mainIdea: $mainIdea, action: $action, email: $email, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestAiEmailImpl &&
            (identical(other.mainIdea, mainIdea) ||
                other.mainIdea == mainIdea) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mainIdea, action, email, metadata);

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestAiEmailImplCopyWith<_$RequestAiEmailImpl> get copyWith =>
      __$$RequestAiEmailImplCopyWithImpl<_$RequestAiEmailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestAiEmailImplToJson(
      this,
    );
  }
}

abstract class _RequestAiEmail implements RequestAiEmail {
  const factory _RequestAiEmail(
      {required final String mainIdea,
      required final String action,
      required final String email,
      required final AiEmailMetadata metadata}) = _$RequestAiEmailImpl;

  factory _RequestAiEmail.fromJson(Map<String, dynamic> json) =
      _$RequestAiEmailImpl.fromJson;

  @override
  String get mainIdea;
  @override
  String get action;
  @override
  String get email;
  @override
  AiEmailMetadata get metadata;

  /// Create a copy of RequestAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestAiEmailImplCopyWith<_$RequestAiEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
