import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../providers/dio_provider.dart';
import '../models/email_models.dart';

final emailApiProvider = Provider<EmailService>((ref) {
  final dio = ref.read(dioProvider);
  return EmailService(dio);
});

class EmailService {
  final Dio _dio;

  EmailService(this._dio);

  Future<dynamic> generateEmail(
      EmailGenerationRequest request, String endpoint) async {
    try {
      request.toJson();
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
      );
      if (endpoint == ApiEndpoints.suggestReplyIdeas) {
        return ReplyIdeasResponse.fromJson(response.data).ideas;
      } else {
        return EmailResponse.fromJson(response.data).email;
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Handle the response from the API
class ReplyIdeasResponse {
  final List<String> ideas;

  ReplyIdeasResponse({required this.ideas});

  factory ReplyIdeasResponse.fromJson(Map<String, dynamic> json) {
    return ReplyIdeasResponse(
      ideas: (json['ideas'] as List).cast<String>(),
    );
  }
}

class EmailResponse {
  final String email;
  final int remainingUsage;

  EmailResponse({required this.email, required this.remainingUsage});

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    return EmailResponse(
      email: json['email'] as String,
      remainingUsage: json['remainingUsage'] as int,
    );
  }
}
