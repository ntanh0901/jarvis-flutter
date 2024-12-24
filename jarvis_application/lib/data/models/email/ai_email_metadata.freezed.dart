// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_email_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiEmailMetadata _$AiEmailMetadataFromJson(Map<String, dynamic> json) {
  return _AiEmailMetadata.fromJson(json);
}

/// @nodoc
mixin _$AiEmailMetadata {
  List<EmailContent> get context => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get receiver => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  AiEmailStyleDto get style => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;

  /// Serializes this AiEmailMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiEmailMetadataCopyWith<AiEmailMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiEmailMetadataCopyWith<$Res> {
  factory $AiEmailMetadataCopyWith(
          AiEmailMetadata value, $Res Function(AiEmailMetadata) then) =
      _$AiEmailMetadataCopyWithImpl<$Res, AiEmailMetadata>;
  @useResult
  $Res call(
      {List<EmailContent> context,
      String language,
      String receiver,
      String sender,
      AiEmailStyleDto style,
      String subject});

  $AiEmailStyleDtoCopyWith<$Res> get style;
}

/// @nodoc
class _$AiEmailMetadataCopyWithImpl<$Res, $Val extends AiEmailMetadata>
    implements $AiEmailMetadataCopyWith<$Res> {
  _$AiEmailMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? language = null,
    Object? receiver = null,
    Object? sender = null,
    Object? style = null,
    Object? subject = null,
  }) {
    return _then(_value.copyWith(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as List<EmailContent>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as AiEmailStyleDto,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiEmailStyleDtoCopyWith<$Res> get style {
    return $AiEmailStyleDtoCopyWith<$Res>(_value.style, (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AiEmailMetadataImplCopyWith<$Res>
    implements $AiEmailMetadataCopyWith<$Res> {
  factory _$$AiEmailMetadataImplCopyWith(_$AiEmailMetadataImpl value,
          $Res Function(_$AiEmailMetadataImpl) then) =
      __$$AiEmailMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EmailContent> context,
      String language,
      String receiver,
      String sender,
      AiEmailStyleDto style,
      String subject});

  @override
  $AiEmailStyleDtoCopyWith<$Res> get style;
}

/// @nodoc
class __$$AiEmailMetadataImplCopyWithImpl<$Res>
    extends _$AiEmailMetadataCopyWithImpl<$Res, _$AiEmailMetadataImpl>
    implements _$$AiEmailMetadataImplCopyWith<$Res> {
  __$$AiEmailMetadataImplCopyWithImpl(
      _$AiEmailMetadataImpl _value, $Res Function(_$AiEmailMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? language = null,
    Object? receiver = null,
    Object? sender = null,
    Object? style = null,
    Object? subject = null,
  }) {
    return _then(_$AiEmailMetadataImpl(
      context: null == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as List<EmailContent>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as AiEmailStyleDto,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiEmailMetadataImpl implements _AiEmailMetadata {
  const _$AiEmailMetadataImpl(
      {required final List<EmailContent> context,
      required this.language,
      required this.receiver,
      required this.sender,
      required this.style,
      required this.subject})
      : _context = context;

  factory _$AiEmailMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiEmailMetadataImplFromJson(json);

  final List<EmailContent> _context;
  @override
  List<EmailContent> get context {
    if (_context is EqualUnmodifiableListView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_context);
  }

  @override
  final String language;
  @override
  final String receiver;
  @override
  final String sender;
  @override
  final AiEmailStyleDto style;
  @override
  final String subject;

  @override
  String toString() {
    return 'AiEmailMetadata(context: $context, language: $language, receiver: $receiver, sender: $sender, style: $style, subject: $subject)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiEmailMetadataImpl &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.subject, subject) || other.subject == subject));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_context),
      language,
      receiver,
      sender,
      style,
      subject);

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiEmailMetadataImplCopyWith<_$AiEmailMetadataImpl> get copyWith =>
      __$$AiEmailMetadataImplCopyWithImpl<_$AiEmailMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiEmailMetadataImplToJson(
      this,
    );
  }
}

abstract class _AiEmailMetadata implements AiEmailMetadata {
  const factory _AiEmailMetadata(
      {required final List<EmailContent> context,
      required final String language,
      required final String receiver,
      required final String sender,
      required final AiEmailStyleDto style,
      required final String subject}) = _$AiEmailMetadataImpl;

  factory _AiEmailMetadata.fromJson(Map<String, dynamic> json) =
      _$AiEmailMetadataImpl.fromJson;

  @override
  List<EmailContent> get context;
  @override
  String get language;
  @override
  String get receiver;
  @override
  String get sender;
  @override
  AiEmailStyleDto get style;
  @override
  String get subject;

  /// Create a copy of AiEmailMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiEmailMetadataImplCopyWith<_$AiEmailMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
