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
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getPrompts,
        queryParameters: {
          if (category != null) 'category': category,
          if (query != null) 'query': query,
          if (isPublic != null) 'isPublic': isPublic,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['items'] as List;
        print('Prompts fetched successfully: ${data.length}');
        return data.map((item) => Prompt.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load prompts');
      }
    } catch (e) {
      print('Error fetching prompts: $e');
      rethrow;
    }
  }

  Future<void> favoritePrompt(String id) async {
    try {
      await _dio.post(
        ApiEndpoints.addFavoritePrompt.replaceFirst('{id}', id),
      );
    } catch (e) {
      print('Error favoriting prompt: $e');
      rethrow;
    }
  }

  Future<void> unfavoritePrompt(String id) async {
    try {
      await _dio.delete(
        ApiEndpoints.removeFromFavorites.replaceFirst('{id}', id),
      );
    } catch (e) {
      print('Error unfavoriting prompt: $e');
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
      await _dio.post(
        ApiEndpoints.createPrompt,
        data: {
          'category': category,
          'content': content,
          'description': description,
          'isPublic': isPublic,
          'language': language,
          'title': title,
        },
      );
      print('Prompt created successfully.');
    } catch (e) {
      print('Error creating prompt: $e');
      rethrow;
    }
  }

  Future<void> updatePrompt({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      await _dio.patch(
        ApiEndpoints.updatePrompt.replaceFirst('{id}', id),
        data: {
          'title': title,
          'content': content,
        },
      );
      print('Prompt updated successfully.');
    } catch (e) {
      print('Error updating prompt: $e');
      rethrow;
    }
  }

  Future<void> deletePrompt(String id) async {
    try {
      await _dio.delete(
        ApiEndpoints.deletePrompt.replaceFirst('{id}', id),
      );
      print('Prompt deleted successfully.');
    } catch (e) {
      print('Error deleting prompt: $e');
      rethrow;
    }
  }

  List<String> getCategories() {
    return categories;
  }
}
