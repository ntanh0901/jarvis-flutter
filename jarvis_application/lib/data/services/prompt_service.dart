import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/core/constants/api_endpoints.dart';

import '../../providers/dio_provider.dart';
import '../models/prompt.dart';

final promptServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return PromptService(dio);
});

class PromptService {
  final Dio _dio;

  // Inject Dio via constructor
  PromptService(this._dio);

  static const List<String> categories = [
    'BUSINESS',
    'CAREER',
    'CHATBOT',
    'CODING',
    'EDUCATION',
    'FUN',
    'MARKETING',
    'OTHER',
    'PRODUCTIVITY',
    'SEO',
    'WRITING',
  ];

  Future<List<Prompt>> getPrompts({
    String? category,
    String? query,
    bool? isPublic,
    bool? isFavorite,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getPrompts,
        queryParameters: {
          if (category != null) 'category': category,
          if (query != null) 'query': query,
          if (isPublic != null) 'isPublic': isPublic,
          if (isFavorite != null) 'isFavorite': isFavorite,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load prompts. Status: ${response.statusCode}');
      }

      if (response.data == null || !response.data.containsKey('items')) {
        throw Exception('Invalid response format');
      }

      final data = response.data['items'] as List;
      return data.map((item) => Prompt.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> favoritePrompt(String id) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addFavoritePrompt.replaceFirst('{id}', id),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to favorite prompt. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unfavoritePrompt(String id) async {
    try {
      final response = await _dio.delete(
        ApiEndpoints.removeFromFavorites.replaceFirst('{id}', id),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to unfavorite prompt. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPrompt({
    required String category,
    required String content,
    required String description,
    required bool isPublic,
    required String language,
    required String title,
  }) async {
    try {
      if (!categories.contains(category.toUpperCase())) {
        throw Exception('Invalid category provided');
      }

      final response = await _dio.post(
        ApiEndpoints.createPrompt,
        data: {
          'category': category.toLowerCase(),
          'content': content,
          'description': description,
          'isPublic': isPublic,
          'language': language,
          'title': title,
        },
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
            'Failed to create prompt. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePrompt({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.updatePrompt.replaceFirst('{id}', id),
        data: {
          'title': title,
          'content': content,
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update prompt. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePrompt(String id) async {
    try {
      final response = await _dio.delete(
        ApiEndpoints.deletePrompt.replaceFirst('{id}', id),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete prompt. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting prompt: $e');
      rethrow;
    }
  }

  List<String> getCategories() {
    return categories;
  }
}
