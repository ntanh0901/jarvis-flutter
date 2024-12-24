// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_ai_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponseAiEmailImpl _$$ResponseAiEmailImplFromJson(
        Map<String, dynamic> json) =>
    _$ResponseAiEmailImpl(
      email: json['email'] as String,
      remainingUsage: (json['remainingUsage'] as num).toInt(),
    );

Map<String, dynamic> _$$ResponseAiEmailImplToJson(
        _$ResponseAiEmailImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'remainingUsage': instance.remainingUsage,
    };
