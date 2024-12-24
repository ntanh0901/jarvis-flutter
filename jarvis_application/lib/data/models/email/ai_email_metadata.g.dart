// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_email_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiEmailMetadataImpl _$$AiEmailMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$AiEmailMetadataImpl(
      context: (json['context'] as List<dynamic>)
          .map((e) => EmailContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      language: json['language'] as String,
      receiver: json['receiver'] as String,
      sender: json['sender'] as String,
      style: AiEmailStyleDto.fromJson(json['style'] as Map<String, dynamic>),
      subject: json['subject'] as String,
    );

Map<String, dynamic> _$$AiEmailMetadataImplToJson(
        _$AiEmailMetadataImpl instance) =>
    <String, dynamic>{
      'context': instance.context,
      'language': instance.language,
      'receiver': instance.receiver,
      'sender': instance.sender,
      'style': instance.style,
      'subject': instance.subject,
    };
