import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_email_style_dto.freezed.dart';
part 'ai_email_style_dto.g.dart';

@freezed
class AiEmailStyleDto with _$AiEmailStyleDto {
  const factory AiEmailStyleDto({
    required String length,
    required String formality,
    required String tone,
  }) = _AiEmailStyleDto;

  factory AiEmailStyleDto.fromJson(Map<String, dynamic> json) =>
      _$AiEmailStyleDtoFromJson(json);
}
