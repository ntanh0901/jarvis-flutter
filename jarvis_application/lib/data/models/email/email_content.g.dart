// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmailContentImpl _$$EmailContentImplFromJson(Map<String, dynamic> json) =>
    _$EmailContentImpl(
      content: json['content'] as String,
      receiver: json['receiver'] as String,
      sender: json['sender'] as String,
      subject: json['subject'] as String,
    );

Map<String, dynamic> _$$EmailContentImplToJson(_$EmailContentImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'receiver': instance.receiver,
      'sender': instance.sender,
      'subject': instance.subject,
    };
