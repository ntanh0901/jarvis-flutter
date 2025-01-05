import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/core/constants/api_endpoints.dart';
import 'package:jarvis_application/data/models/kb_unit.dart';

import '../../providers/dio_provider.dart';
import '../models/knowledge_base.dart';

final kbServiceProvider = Provider((ref) {
  final dioKB = ref.watch(dioKBProvider);
  return KBService(dioKB);
});

class KBService {
  final DioKB _dioKB;

  // Inject DioKB via constructor
  KBService(this._dioKB);

  Future<List<KnowledgeResDto>> getKnowledgeBases({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dioKB.dio.get(
        ApiEndpoints.getKB,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load knowledge bases. Status: ${response.statusCode}');
      }

      if (response.data == null || !response.data.containsKey('data')) {
        throw Exception('Invalid response format');
      }

      final data = response.data['data'] as List;
      return data.map((item) => KnowledgeResDto.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<KnowledgeResDto> getKnowledgeBase(String id) async {
    try {
      final response = await _dioKB.dio.get(
        ApiEndpoints.getKB.replaceFirst('{id}', id),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load knowledge base. Status: ${response.statusCode}');
      }

      if (response.data == null || !response.data.containsKey('data')) {
        throw Exception('Invalid response format');
      }

      return KnowledgeResDto.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createKnowledgeBase({
    required String knowledgeName,
    required String description,
  }) async {
    try {
      final response = await _dioKB.dio.post(
        ApiEndpoints.createKB,
        data: {
          'knowledgeName': knowledgeName,
          'description': description,
        },
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
            'Failed to create knowledge base. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateKnowledgeBase({
    required String id,
    required String knowledgeName,
    required String description,
  }) async {
    try {
      final response = await _dioKB.dio.patch(
        ApiEndpoints.updateKB.replaceFirst('{id}', id),
        data: {
          'knowledgeName': knowledgeName,
          'description': description,
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update knowledge base. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteKnowledgeBase(String id) async {
    try {
      final response = await _dioKB.dio.delete(
        ApiEndpoints.deleteKB.replaceFirst('{id}', id),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete knowledge base. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting knowledge base: $e');
      rethrow;
    }
  }

  Future<List<Unit>> getKnowledgeBaseUnits(String id) async {
    try {
      final response = await _dioKB.dio.get(
        ApiEndpoints.getKBUnits.replaceFirst('{id}', id),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load knowledge base units. Status: ${response.statusCode}');
      }

      if (response.data == null || !response.data.containsKey('data')) {
        throw Exception('Invalid response format');
      }

      final data = response.data['data'] as List;
      return data.map((item) => Unit.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  String _detectMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  Future<void> addLocalFileUnit(
    String id,
    String fileName,
    Uint8List fileBytes,
  ) async {
    try {
      final mimeType = _detectMimeType(fileName);
      final parts = mimeType.split('/');
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: DioMediaType(parts[0], parts[1]),
        ),
      });

      final response = await _dioKB.dio.post(
        ApiEndpoints.localFile.replaceFirst('{id}', id),
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to add local file unit. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addWebsiteUnit(
      String id, String websiteName, String websiteUrl) async {
    try {
      final response = await _dioKB.dio.post(
        ApiEndpoints.website.replaceFirst('{id}', id),
        data: {
          'unitName': websiteName,
          'webUrl': websiteUrl,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to add website unit. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addSlackUnit(String id, String slackWorkspace,
      String slackBotToken, String unitName) async {
    try {
      final response = await _dioKB.dio.post(
        ApiEndpoints.slack.replaceFirst('{id}', id),
        data: {
          'unitName': unitName,
          'slackWorkspace': slackWorkspace,
          'slackBotToken': slackBotToken,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to add Slack unit. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addConfluenceUnit(String id, String name, String wikiPageUrl,
      String confluenceUsername, String confluenceAccessToken) async {
    try {
      final response = await _dioKB.dio.post(
        ApiEndpoints.confluence.replaceFirst('{id}', id),
        data: {
          'unitName': name,
          'wikiPageUrl': wikiPageUrl,
          'confluenceUsername': confluenceUsername,
          'confluenceAccessToken': confluenceAccessToken,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to add Confluence unit. Status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
