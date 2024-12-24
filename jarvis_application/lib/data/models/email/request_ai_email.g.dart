// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_ai_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestAiEmailImpl _$$RequestAiEmailImplFromJson(Map<String, dynamic> json) =>
    _$RequestAiEmailImpl(
      mainIdea: json['mainIdea'] as String,
      action: json['action'] as String,
      email: json['email'] as String,
      metadata:
          AiEmailMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RequestAiEmailImplToJson(
        _$RequestAiEmailImpl instance) =>
    <String, dynamic>{
      'mainIdea': instance.mainIdea,
      'action': instance.action,
      'email': instance.email,
      'metadata': instance.metadata,
    };
