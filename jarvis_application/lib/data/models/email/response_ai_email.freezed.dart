// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_ai_email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponseAiEmail _$ResponseAiEmailFromJson(Map<String, dynamic> json) {
  return _ResponseAiEmail.fromJson(json);
}

/// @nodoc
mixin _$ResponseAiEmail {
  String get email => throw _privateConstructorUsedError;
  int get remainingUsage => throw _privateConstructorUsedError;

  /// Serializes this ResponseAiEmail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponseAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseAiEmailCopyWith<ResponseAiEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseAiEmailCopyWith<$Res> {
  factory $ResponseAiEmailCopyWith(
          ResponseAiEmail value, $Res Function(ResponseAiEmail) then) =
      _$ResponseAiEmailCopyWithImpl<$Res, ResponseAiEmail>;
  @useResult
  $Res call({String email, int remainingUsage});
}

/// @nodoc
class _$ResponseAiEmailCopyWithImpl<$Res, $Val extends ResponseAiEmail>
    implements $ResponseAiEmailCopyWith<$Res> {
  _$ResponseAiEmailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponseAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? remainingUsage = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      remainingUsage: null == remainingUsage
          ? _value.remainingUsage
          : remainingUsage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseAiEmailImplCopyWith<$Res>
    implements $ResponseAiEmailCopyWith<$Res> {
  factory _$$ResponseAiEmailImplCopyWith(_$ResponseAiEmailImpl value,
          $Res Function(_$ResponseAiEmailImpl) then) =
      __$$ResponseAiEmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, int remainingUsage});
}

/// @nodoc
class __$$ResponseAiEmailImplCopyWithImpl<$Res>
    extends _$ResponseAiEmailCopyWithImpl<$Res, _$ResponseAiEmailImpl>
    implements _$$ResponseAiEmailImplCopyWith<$Res> {
  __$$ResponseAiEmailImplCopyWithImpl(
      _$ResponseAiEmailImpl _value, $Res Function(_$ResponseAiEmailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponseAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? remainingUsage = null,
  }) {
    return _then(_$ResponseAiEmailImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      remainingUsage: null == remainingUsage
          ? _value.remainingUsage
          : remainingUsage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponseAiEmailImpl implements _ResponseAiEmail {
  const _$ResponseAiEmailImpl(
      {required this.email, required this.remainingUsage});

  factory _$ResponseAiEmailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseAiEmailImplFromJson(json);

  @override
  final String email;
  @override
  final int remainingUsage;

  @override
  String toString() {
    return 'ResponseAiEmail(email: $email, remainingUsage: $remainingUsage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseAiEmailImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.remainingUsage, remainingUsage) ||
                other.remainingUsage == remainingUsage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, remainingUsage);

  /// Create a copy of ResponseAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseAiEmailImplCopyWith<_$ResponseAiEmailImpl> get copyWith =>
      __$$ResponseAiEmailImplCopyWithImpl<_$ResponseAiEmailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseAiEmailImplToJson(
      this,
    );
  }
}

abstract class _ResponseAiEmail implements ResponseAiEmail {
  const factory _ResponseAiEmail(
      {required final String email,
      required final int remainingUsage}) = _$ResponseAiEmailImpl;

  factory _ResponseAiEmail.fromJson(Map<String, dynamic> json) =
      _$ResponseAiEmailImpl.fromJson;

  @override
  String get email;
  @override
  int get remainingUsage;

  /// Create a copy of ResponseAiEmail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseAiEmailImplCopyWith<_$ResponseAiEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
