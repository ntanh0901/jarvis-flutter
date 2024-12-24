import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dio_provider.dart';
import '../models/email/request_ai_email.dart';
import '../models/email/response_ai_email.dart';
import '../models/email/response_ai_email_ideas.dart';

final emailApiProvider = Provider<EmailApi>((ref) {
  final dio = ref.read(dioProvider);
  return EmailApi(dio);
});

class EmailApi {
  final Dio _dio;

  EmailApi(this._dio);

  Future<ResponseAiEmail> sendEmail(RequestAiEmail request) async {
    final response =
        await _dio.post('/api/v1/ai-email', data: request.toJson());
    return ResponseAiEmail.fromJson(response.data);
  }

  Future<ResponseAiEmailIdeas> getReplyIdeas(RequestAiEmail request) async {
    final response =
        await _dio.post('/api/v1/ai-email/reply-ideas', data: request.toJson());
    return ResponseAiEmailIdeas.fromJson(response.data);
  }
}
