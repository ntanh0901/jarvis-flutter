import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_email_style_dto.dart';
import 'email_content.dart';

part 'ai_email_metadata.freezed.dart';
part 'ai_email_metadata.g.dart';

@freezed
class AiEmailMetadata with _$AiEmailMetadata {
  const factory AiEmailMetadata({
    required List<EmailContent> context,
    required String language,
    required String receiver,
    required String sender,
    required AiEmailStyleDto style,
    required String subject,
  }) = _AiEmailMetadata;

  factory AiEmailMetadata.fromJson(Map<String, dynamic> json) =>
      _$AiEmailMetadataFromJson(json);
}
