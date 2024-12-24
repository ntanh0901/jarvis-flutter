// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_email_style_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiEmailStyleDto _$AiEmailStyleDtoFromJson(Map<String, dynamic> json) {
  return _AiEmailStyleDto.fromJson(json);
}

/// @nodoc
mixin _$AiEmailStyleDto {
  String get length => throw _privateConstructorUsedError;
  String get formality => throw _privateConstructorUsedError;
  String get tone => throw _privateConstructorUsedError;

  /// Serializes this AiEmailStyleDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiEmailStyleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiEmailStyleDtoCopyWith<AiEmailStyleDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiEmailStyleDtoCopyWith<$Res> {
  factory $AiEmailStyleDtoCopyWith(
          AiEmailStyleDto value, $Res Function(AiEmailStyleDto) then) =
      _$AiEmailStyleDtoCopyWithImpl<$Res, AiEmailStyleDto>;
  @useResult
  $Res call({String length, String formality, String tone});
}

/// @nodoc
class _$AiEmailStyleDtoCopyWithImpl<$Res, $Val extends AiEmailStyleDto>
    implements $AiEmailStyleDtoCopyWith<$Res> {
  _$AiEmailStyleDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiEmailStyleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? length = null,
    Object? formality = null,
    Object? tone = null,
  }) {
    return _then(_value.copyWith(
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as String,
      formality: null == formality
          ? _value.formality
          : formality // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _value.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiEmailStyleDtoImplCopyWith<$Res>
    implements $AiEmailStyleDtoCopyWith<$Res> {
  factory _$$AiEmailStyleDtoImplCopyWith(_$AiEmailStyleDtoImpl value,
          $Res Function(_$AiEmailStyleDtoImpl) then) =
      __$$AiEmailStyleDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String length, String formality, String tone});
}

/// @nodoc
class __$$AiEmailStyleDtoImplCopyWithImpl<$Res>
    extends _$AiEmailStyleDtoCopyWithImpl<$Res, _$AiEmailStyleDtoImpl>
    implements _$$AiEmailStyleDtoImplCopyWith<$Res> {
  __$$AiEmailStyleDtoImplCopyWithImpl(
      _$AiEmailStyleDtoImpl _value, $Res Function(_$AiEmailStyleDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiEmailStyleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? length = null,
    Object? formality = null,
    Object? tone = null,
  }) {
    return _then(_$AiEmailStyleDtoImpl(
      length: null == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as String,
      formality: null == formality
          ? _value.formality
          : formality // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _value.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiEmailStyleDtoImpl implements _AiEmailStyleDto {
  const _$AiEmailStyleDtoImpl(
      {required this.length, required this.formality, required this.tone});

  factory _$AiEmailStyleDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiEmailStyleDtoImplFromJson(json);

  @override
  final String length;
  @override
  final String formality;
  @override
  final String tone;

  @override
  String toString() {
    return 'AiEmailStyleDto(length: $length, formality: $formality, tone: $tone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiEmailStyleDtoImpl &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.formality, formality) ||
                other.formality == formality) &&
            (identical(other.tone, tone) || other.tone == tone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, length, formality, tone);

  /// Create a copy of AiEmailStyleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiEmailStyleDtoImplCopyWith<_$AiEmailStyleDtoImpl> get copyWith =>
      __$$AiEmailStyleDtoImplCopyWithImpl<_$AiEmailStyleDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiEmailStyleDtoImplToJson(
      this,
    );
  }
}

abstract class _AiEmailStyleDto implements AiEmailStyleDto {
  const factory _AiEmailStyleDto(
      {required final String length,
      required final String formality,
      required final String tone}) = _$AiEmailStyleDtoImpl;

  factory _AiEmailStyleDto.fromJson(Map<String, dynamic> json) =
      _$AiEmailStyleDtoImpl.fromJson;

  @override
  String get length;
  @override
  String get formality;
  @override
  String get tone;

  /// Create a copy of AiEmailStyleDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiEmailStyleDtoImplCopyWith<_$AiEmailStyleDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
