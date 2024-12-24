import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_ai_email.freezed.dart';
part 'response_ai_email.g.dart';

@freezed
class ResponseAiEmail with _$ResponseAiEmail {
  const factory ResponseAiEmail({
    required String email,
    required int remainingUsage,
  }) = _ResponseAiEmail;

  factory ResponseAiEmail.fromJson(Map<String, dynamic> json) =>
      _$ResponseAiEmailFromJson(json);
}
