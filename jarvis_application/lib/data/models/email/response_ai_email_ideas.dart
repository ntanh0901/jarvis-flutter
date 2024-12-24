import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_ai_email_ideas.freezed.dart';
part 'response_ai_email_ideas.g.dart';

@freezed
class ResponseAiEmailIdeas with _$ResponseAiEmailIdeas {
  const factory ResponseAiEmailIdeas({
    required List<String> ideas,
  }) = _ResponseAiEmailIdeas;

  factory ResponseAiEmailIdeas.fromJson(Map<String, dynamic> json) =>
      _$ResponseAiEmailIdeasFromJson(json);
}
