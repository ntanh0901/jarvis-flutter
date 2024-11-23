import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.dev.jarvis.cx';
  static String? accessToken;
  static String? refreshToken;

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

  static Future<void> signIn() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'ntanh.fit@gmail.com',
        'password': 'JarvisApplication123!',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['token']['accessToken'];
      refreshToken = data['token']['refreshToken'];
      print('Signed in successfully. Access token: $accessToken');
    } else {
      print('Failed to sign in. Status code: ${response.statusCode}');
      throw Exception('Failed to sign in');
    }
  }

  static Future<void> refreshAccessToken() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['token']['accessToken'];
      print('Token refreshed successfully. New access token: $accessToken');
    } else {
      print('Failed to refresh token. Status code: ${response.statusCode}');
      throw Exception('Failed to refresh token');
    }
  }

  static Future<List<Item>> getPrompts(
      {String? category, String? query, bool? isPublic}) async {
    if (accessToken == null) {
      await signIn();
    }

    final uri = Uri.parse('$baseUrl/api/v1/prompts').replace(queryParameters: {
      if (category != null) 'category': category,
      if (query != null) 'query': query,
      if (isPublic != null) 'isPublic': isPublic.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return getPrompts(category: category, query: query, isPublic: isPublic);
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Prompts fetched successfully.');
      print('Prompts count: ${data['items'].length}');
      return (data['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList();
    } else {
      print('Failed to load prompts. Status code: ${response.statusCode}');
      throw Exception('Failed to load prompts');
    }
  }

  static Future<void> favoritePrompt(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/prompts/$id/favorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return favoritePrompt(id);
    }

    if (response.statusCode != 201) {
      print('Failed to favorite prompt. Status code: ${response.statusCode}');
      throw Exception('Failed to favorite prompt');
    }
  }

  static Future<void> unfavoritePrompt(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/prompts/$id/favorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return unfavoritePrompt(id);
    }

    if (response.statusCode != 200) {
      print('Failed to unfavorite prompt. Status code: ${response.statusCode}');
      throw Exception('Failed to unfavorite prompt');
    }
  }

  static Future<void> createPrompt({
    required String category,
    required String content,
    required String description,
    required bool isPublic,
    required String language,
    required String title,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/prompts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'category': category,
        'content': content,
        'description': description,
        'isPublic': isPublic,
        'language': language,
        'title': title,
      }),
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return createPrompt(
        category: category,
        content: content,
        description: description,
        isPublic: isPublic,
        language: language,
        title: title,
      );
    }

    if (response.statusCode != 201) {
      print(response.body);
      print('Failed to create prompt. Status code: ${response.statusCode}');
      throw Exception('Failed to create prompt');
    }
  }

  static Future<void> updatePrompt({
    required String id,
    required String title,
    required String content,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/v1/prompts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return updatePrompt(id: id, title: title, content: content);
    }

    if (response.statusCode != 200) {
      print('Failed to update prompt. Status code: ${response.statusCode}');
      throw Exception('Failed to update prompt');
    }
  }

  static Future<void> deletePrompt(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/prompts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      return deletePrompt(id);
    }

    if (response.statusCode != 200) {
      print('Failed to delete prompt. Status code: ${response.statusCode}');
      throw Exception('Failed to delete prompt');
    }
  }

  static Future<List<Item>> getPromptsForChat() async {
    try {
      final privatePrompts = await getPrompts(isPublic: false);
      final favoritePrompts = await getPrompts(isPublic: true);
      return [
        ...privatePrompts,
        ...favoritePrompts.where((prompt) => prompt.isFavorite == true)
      ];
    } catch (e) {
      print('Error fetching my prompts for chat: $e');
      throw Exception('Error fetching my prompts for chat');
    }
  }
}

class Item {
  final String id;
  final String? category;
  String content;
  final String createdAt;
  final String? description;
  bool? isFavorite;
  bool? isPublic;
  final String? language;
  String title;
  final String updatedAt;
  final String? userId;
  final String? userName;

  Item({
    required this.id,
    this.category,
    required this.content,
    required this.createdAt,
    this.description,
    this.isFavorite,
    this.isPublic,
    this.language,
    required this.title,
    required this.updatedAt,
    this.userId,
    this.userName,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      category: json['category'],
      content: json['content'],
      createdAt: json['createdAt'],
      description: json['description'],
      isFavorite: json['isFavorite'],
      isPublic: json['isPublic'],
      language: json['language'],
      title: json['title'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}
