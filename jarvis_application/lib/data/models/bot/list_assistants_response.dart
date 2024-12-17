import 'ai_assistant.dart';
import 'meta_data.dart';

class ListAssistantsResponse {
  final List<AIAssistant> data;
  final MetaData meta;

  ListAssistantsResponse({
    required this.data,
    required this.meta,
  });

  factory ListAssistantsResponse.fromJson(Map<String, dynamic> json) {
    return ListAssistantsResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => AIAssistant.fromJson(item))
          .toList(),
      meta: MetaData.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((assistant) => assistant.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'ListAssistantsResponse{data: $data, meta: $meta}';
  }
}