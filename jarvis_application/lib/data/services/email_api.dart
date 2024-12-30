import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final i = request.toJson();
    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
