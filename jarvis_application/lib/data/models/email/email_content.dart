import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_content.freezed.dart';
part 'email_content.g.dart';

@freezed
class EmailContent with _$EmailContent {
  const factory EmailContent({
    required String content,
    required String receiver,
    required String sender,
    required String subject,
  }) = _EmailContent;

  factory EmailContent.fromJson(Map<String, dynamic> json) =>
      _$EmailContentFromJson(json);
}
