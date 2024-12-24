// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_ai_email_ideas.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponseAiEmailIdeas _$ResponseAiEmailIdeasFromJson(Map<String, dynamic> json) {
  return _ResponseAiEmailIdeas.fromJson(json);
}

/// @nodoc
mixin _$ResponseAiEmailIdeas {
  List<String> get ideas => throw _privateConstructorUsedError;

  /// Serializes this ResponseAiEmailIdeas to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponseAiEmailIdeas
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseAiEmailIdeasCopyWith<ResponseAiEmailIdeas> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseAiEmailIdeasCopyWith<$Res> {
  factory $ResponseAiEmailIdeasCopyWith(ResponseAiEmailIdeas value,
          $Res Function(ResponseAiEmailIdeas) then) =
      _$ResponseAiEmailIdeasCopyWithImpl<$Res, ResponseAiEmailIdeas>;
  @useResult
  $Res call({List<String> ideas});
}

/// @nodoc
class _$ResponseAiEmailIdeasCopyWithImpl<$Res,
        $Val extends ResponseAiEmailIdeas>
    implements $ResponseAiEmailIdeasCopyWith<$Res> {
  _$ResponseAiEmailIdeasCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponseAiEmailIdeas
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ideas = null,
  }) {
    return _then(_value.copyWith(
      ideas: null == ideas
          ? _value.ideas
          : ideas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseAiEmailIdeasImplCopyWith<$Res>
    implements $ResponseAiEmailIdeasCopyWith<$Res> {
  factory _$$ResponseAiEmailIdeasImplCopyWith(_$ResponseAiEmailIdeasImpl value,
          $Res Function(_$ResponseAiEmailIdeasImpl) then) =
      __$$ResponseAiEmailIdeasImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ideas});
}

/// @nodoc
class __$$ResponseAiEmailIdeasImplCopyWithImpl<$Res>
    extends _$ResponseAiEmailIdeasCopyWithImpl<$Res, _$ResponseAiEmailIdeasImpl>
    implements _$$ResponseAiEmailIdeasImplCopyWith<$Res> {
  __$$ResponseAiEmailIdeasImplCopyWithImpl(_$ResponseAiEmailIdeasImpl _value,
      $Res Function(_$ResponseAiEmailIdeasImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponseAiEmailIdeas
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ideas = null,
  }) {
    return _then(_$ResponseAiEmailIdeasImpl(
      ideas: null == ideas
          ? _value._ideas
          : ideas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponseAiEmailIdeasImpl implements _ResponseAiEmailIdeas {
  const _$ResponseAiEmailIdeasImpl({required final List<String> ideas})
      : _ideas = ideas;

  factory _$ResponseAiEmailIdeasImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseAiEmailIdeasImplFromJson(json);

  final List<String> _ideas;
  @override
  List<String> get ideas {
    if (_ideas is EqualUnmodifiableListView) return _ideas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ideas);
  }

  @override
  String toString() {
    return 'ResponseAiEmailIdeas(ideas: $ideas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseAiEmailIdeasImpl &&
            const DeepCollectionEquality().equals(other._ideas, _ideas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_ideas));

  /// Create a copy of ResponseAiEmailIdeas
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseAiEmailIdeasImplCopyWith<_$ResponseAiEmailIdeasImpl>
      get copyWith =>
          __$$ResponseAiEmailIdeasImplCopyWithImpl<_$ResponseAiEmailIdeasImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseAiEmailIdeasImplToJson(
      this,
    );
  }
}

abstract class _ResponseAiEmailIdeas implements ResponseAiEmailIdeas {
  const factory _ResponseAiEmailIdeas({required final List<String> ideas}) =
      _$ResponseAiEmailIdeasImpl;

  factory _ResponseAiEmailIdeas.fromJson(Map<String, dynamic> json) =
      _$ResponseAiEmailIdeasImpl.fromJson;

  @override
  List<String> get ideas;

  /// Create a copy of ResponseAiEmailIdeas
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseAiEmailIdeasImplCopyWith<_$ResponseAiEmailIdeasImpl>
      get copyWith => throw _privateConstructorUsedError;
}
