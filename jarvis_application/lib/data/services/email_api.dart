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
    try {
      final response =
          await _dio.post('/api/v1/ai-email', data: request.toJson());
      if (response.statusCode == 200) {
        return ResponseAiEmail.fromJson(response.data);
      } else {
        throw Exception('Failed to send email: ${response.statusCode}');
      }
    } on Exception catch (e) {
      // TODO: Handle the exception appropriately
      print(e);
      rethrow;
    }
  }

  Future<ResponseAiEmailIdeas> getReplyIdeas(RequestAiEmail request) async {
    final response =
        await _dio.post('/api/v1/ai-email/reply-ideas', data: request.toJson());
    return ResponseAiEmailIdeas.fromJson(response.data);
  }
}
