// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmailContent _$EmailContentFromJson(Map<String, dynamic> json) {
  return _EmailContent.fromJson(json);
}

/// @nodoc
mixin _$EmailContent {
  String get content => throw _privateConstructorUsedError;
  String get receiver => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;

  /// Serializes this EmailContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmailContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailContentCopyWith<EmailContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailContentCopyWith<$Res> {
  factory $EmailContentCopyWith(
          EmailContent value, $Res Function(EmailContent) then) =
      _$EmailContentCopyWithImpl<$Res, EmailContent>;
  @useResult
  $Res call({String content, String receiver, String sender, String subject});
}

/// @nodoc
class _$EmailContentCopyWithImpl<$Res, $Val extends EmailContent>
    implements $EmailContentCopyWith<$Res> {
  _$EmailContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? receiver = null,
    Object? sender = null,
    Object? subject = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailContentImplCopyWith<$Res>
    implements $EmailContentCopyWith<$Res> {
  factory _$$EmailContentImplCopyWith(
          _$EmailContentImpl value, $Res Function(_$EmailContentImpl) then) =
      __$$EmailContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, String receiver, String sender, String subject});
}

/// @nodoc
class __$$EmailContentImplCopyWithImpl<$Res>
    extends _$EmailContentCopyWithImpl<$Res, _$EmailContentImpl>
    implements _$$EmailContentImplCopyWith<$Res> {
  __$$EmailContentImplCopyWithImpl(
      _$EmailContentImpl _value, $Res Function(_$EmailContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmailContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? receiver = null,
    Object? sender = null,
    Object? subject = null,
  }) {
    return _then(_$EmailContentImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailContentImpl implements _EmailContent {
  const _$EmailContentImpl(
      {required this.content,
      required this.receiver,
      required this.sender,
      required this.subject});

  factory _$EmailContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailContentImplFromJson(json);

  @override
  final String content;
  @override
  final String receiver;
  @override
  final String sender;
  @override
  final String subject;

  @override
  String toString() {
    return 'EmailContent(content: $content, receiver: $receiver, sender: $sender, subject: $subject)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailContentImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.subject, subject) || other.subject == subject));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, content, receiver, sender, subject);

  /// Create a copy of EmailContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailContentImplCopyWith<_$EmailContentImpl> get copyWith =>
      __$$EmailContentImplCopyWithImpl<_$EmailContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailContentImplToJson(
      this,
    );
  }
}

abstract class _EmailContent implements EmailContent {
  const factory _EmailContent(
      {required final String content,
      required final String receiver,
      required final String sender,
      required final String subject}) = _$EmailContentImpl;

  factory _EmailContent.fromJson(Map<String, dynamic> json) =
      _$EmailContentImpl.fromJson;

  @override
  String get content;
  @override
  String get receiver;
  @override
  String get sender;
  @override
  String get subject;

  /// Create a copy of EmailContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailContentImplCopyWith<_$EmailContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
