import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/data/services/knowledge_base_service.dart';

import '../../data/models/knowledge_base.dart';
import '../../data/models/kb_unit.dart';

class KBState {
  final bool isLoading;
  final List<KnowledgeResDto> knowledgeBases;
  final List<KnowledgeResDto> filteredKnowledgeBases;
  final List<Unit> units;
  final String searchQuery;

  KBState({
    this.isLoading = true,
    this.knowledgeBases = const [],
    this.filteredKnowledgeBases = const [],
    this.units = const [],
    this.searchQuery = '',
  });

  KBState copyWith({
    bool? isLoading,
    List<KnowledgeResDto>? knowledgeBases,
    List<KnowledgeResDto>? filteredKnowledgeBases,
    List<Unit>? units,
    String? searchQuery,
  }) {
    return KBState(
      isLoading: isLoading ?? this.isLoading,
      knowledgeBases: knowledgeBases ?? this.knowledgeBases,
      filteredKnowledgeBases:
          filteredKnowledgeBases ?? this.filteredKnowledgeBases,
      units: units ?? this.units,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class KBNotifier extends StateNotifier<KBState> {
  final KBService _kbService;

  KBNotifier(this._kbService) : super(KBState());

  Future init() async {
    await fetchKnowledgeBases();
  }

  Future<void> fetchKnowledgeBases({int limit = 20, int offset = 0}) async {
    try {
      final knowledgeBases =
          await _kbService.getKnowledgeBases(limit: limit, offset: offset);
      if (!mounted) return;
      state = state.copyWith(
        knowledgeBases: knowledgeBases,
        filteredKnowledgeBases: knowledgeBases,
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching knowledge bases: $e');
    }
  }

  Future<void> fetchKnowledgeBaseDetails(String id) async {
    try {
      final knowledgeBase = await _kbService.getKnowledgeBase(id);
      if (!mounted) return;
      final updatedKnowledgeBases = state.knowledgeBases.map((kb) {
        return kb.id == id ? knowledgeBase : kb;
      }).toList();
      state = state.copyWith(
        knowledgeBases: updatedKnowledgeBases,
        filteredKnowledgeBases: updatedKnowledgeBases,
      );
    } catch (e) {
      print('Error fetching knowledge base details: $e');
    }
  }

  Future<void> createKnowledgeBase(
      String knowledgeName, String description) async {
    try {
      await _kbService.createKnowledgeBase(
          knowledgeName: knowledgeName, description: description);
      await fetchKnowledgeBases();
    } catch (e) {
      print('Error creating knowledge base: $e');
    }
  }

  Future<void> updateKnowledgeBase(
      String id, String knowledgeName, String description) async {
    try {
      await _kbService.updateKnowledgeBase(
          id: id, knowledgeName: knowledgeName, description: description);
      await fetchKnowledgeBases();
    } catch (e) {
      print('Error updating knowledge base: $e');
    }
  }

  Future<void> deleteKnowledgeBase(String id) async {
    try {
      await _kbService.deleteKnowledgeBase(id);
      await fetchKnowledgeBases();
    } catch (e) {
      print('Error deleting knowledge base: $e');
    }
  }

  Future<void> fetchKnowledgeBaseUnits(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final units = await _kbService.getKnowledgeBaseUnits(id);
      state = state.copyWith(isLoading: false, units: units);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error fetching knowledge base units: $e');
    }
  }

  Future<void> addLocalFileUnit(
      String id, String fileName, Uint8List fileBytes) async {
    try {
      await _kbService.addLocalFileUnit(id, fileName, fileBytes);
    } catch (e) {
      print('Error adding local file unit: $e');
      rethrow;
    }
  }

  Future<void> addWebsiteUnit(
      String id, String websiteName, String websiteUrl) async {
    try {
      await _kbService.addWebsiteUnit(id, websiteName, websiteUrl);
    } catch (e) {
      print('Error adding website unit: $e');
      rethrow;
    }
  }

  Future<void> addSlackUnit(String id, String slackWorkspace,
      String slackBotToken, String unitName) async {
    try {
      await _kbService.addSlackUnit(
          id, slackWorkspace, slackBotToken, unitName);
    } catch (e) {
      print('Error adding Slack unit: $e');
      rethrow;
    }
  }

  Future<void> addConfluenceUnit(String id, String name, String wikiPageUrl,
      String confluenceUsername, String confluenceAccessToken) async {
    try {
      await _kbService.addConfluenceUnit(
          id, name, wikiPageUrl, confluenceUsername, confluenceAccessToken);
    } catch (e) {
      print('Error adding Confluence unit: $e');
      rethrow;
    }
  }

  void filterKnowledgeBases() {
    bool matchesQuery(KnowledgeResDto knowledgeBase) {
      return state.searchQuery.isEmpty ||
          knowledgeBase.knowledgeName
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase()) ||
          knowledgeBase.description
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase());
    }

    state = state.copyWith(
      filteredKnowledgeBases: state.knowledgeBases.where(matchesQuery).toList(),
    );
  }

  void changeSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    filterKnowledgeBases();
  }
}

final kbViewModelProvider = StateNotifierProvider<KBNotifier, KBState>((ref) {
  final kbService = ref.watch(kbServiceProvider);
  return KBNotifier(kbService);
});
