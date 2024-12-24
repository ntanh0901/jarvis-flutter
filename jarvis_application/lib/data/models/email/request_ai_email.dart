import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_email_metadata.dart';

part 'request_ai_email.freezed.dart';
part 'request_ai_email.g.dart';

@freezed
class RequestAiEmail with _$RequestAiEmail {
  const factory RequestAiEmail({
    required String mainIdea,
    required String action,
    required String email,
    required AiEmailMetadata metadata,
  }) = _RequestAiEmail;

  factory RequestAiEmail.fromJson(Map<String, dynamic> json) =>
      _$RequestAiEmailFromJson(json);
}
