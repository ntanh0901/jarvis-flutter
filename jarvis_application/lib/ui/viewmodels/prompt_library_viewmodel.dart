import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/prompt.dart';
import '../../data/services/prompt_service.dart';

class PromptLibraryState {
  final bool isLoading;
  final bool isMyPromptSelected;
  final List<Prompt> myPrompts;
  final List<Prompt> publicPrompts;
  final List<Prompt> filteredPrompts;
  final List<String> selectedCategories;
  final String searchQuery;
  final List<String> categories;

  PromptLibraryState({
    this.isLoading = true,
    this.isMyPromptSelected = true,
    this.myPrompts = const [],
    this.publicPrompts = const [],
    this.filteredPrompts = const [],
    this.selectedCategories = const [],
    this.searchQuery = '',
    this.categories = const [],
  });

  PromptLibraryState copyWith({
    bool? isLoading,
    bool? isMyPromptSelected,
    List<Prompt>? myPrompts,
    List<Prompt>? publicPrompts,
    List<Prompt>? filteredPrompts,
    List<String>? selectedCategories,
    String? searchQuery,
    List<String>? categories,
  }) {
    return PromptLibraryState(
      isLoading: isLoading ?? this.isLoading,
      isMyPromptSelected: isMyPromptSelected ?? this.isMyPromptSelected,
      myPrompts: myPrompts ?? this.myPrompts,
      publicPrompts: publicPrompts ?? this.publicPrompts,
      filteredPrompts: filteredPrompts ?? this.filteredPrompts,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
    );
  }
}

class PromptNotifier extends StateNotifier<PromptLibraryState> {
  final PromptService _promptService;

  PromptNotifier(this._promptService) : super(PromptLibraryState());

  Future init() async {
    await Future.wait([
      fetchMyPrompts(),
      fetchPublicPrompts(),
    ]);
  }

  Future<void> fetchMyPrompts({int limit = 20, int offset = 0}) async {
    try {
      final privatePrompts = await _promptService.getPrompts(
          isPublic: false, limit: limit, offset: offset);
      final favoritePrompts = await _promptService.getPrompts(
          isPublic: true, limit: limit, offset: offset);
      if (!mounted) return;
      state = state.copyWith(
        myPrompts: [
          ...state.myPrompts,
          ...privatePrompts,
          ...favoritePrompts.where((prompt) => prompt.isFavorite == true),
        ],
      );
    } catch (e) {
      print('Error fetching my prompts: $e');
    }
  }

  Future<void> fetchPublicPrompts({int limit = 20, int offset = 0}) async {
    try {
      final fetchedPrompts = await _promptService.getPrompts(
          isPublic: true, limit: limit, offset: offset);
      final fetchedCategories = fetchedPrompts
          .map((prompt) => prompt.category)
          .whereType<String>()
          .toSet()
          .toList();

      // Update categories only if there are new categories
      final newCategories = fetchedCategories
          .where((category) => !state.categories.contains(category))
          .toList();
      final updatedCategories = state.categories.contains('All')
          ? [...state.categories, ...newCategories]
          : ['All', ...state.categories, ...newCategories];

      if (!mounted) return;
      state = state.copyWith(
        publicPrompts: [
          ...state.publicPrompts,
          ...fetchedPrompts,
        ],
        filteredPrompts: [
          ...state.filteredPrompts,
          ...fetchedPrompts,
        ],
        categories: updatedCategories,
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching public prompts: $e');
    }
  }

  Future<void> loadMorePrompts() async {
    if (state.isMyPromptSelected) {
      await fetchMyPrompts(limit: 20, offset: state.myPrompts.length);
    } else {
      await fetchPublicPrompts(limit: 20, offset: state.publicPrompts.length);
    }
  }

  Future<void> refreshPrompts() async {
    await fetchMyPrompts();
    await fetchPublicPrompts();
  }

  Future<void> deletePrompt(String id) async {
    try {
      await _promptService.deletePrompt(id);
    } catch (e) {
      print('Error deleting prompt: $e');
    }
  }

  Future<void> toggleFavorite(Prompt prompt) async {
    try {
      final newFavoriteStatus = !(prompt.isFavorite ?? false);

      if (newFavoriteStatus) {
        await _promptService.favoritePrompt(prompt.id);
      } else {
        await _promptService.unfavoritePrompt(prompt.id);
      }

      // Update local prompt object
      prompt.isFavorite = newFavoriteStatus;

      // 1) Update myPrompts in memory
      //    - Add prompt if it is now a favorite and isPublic == true
      //    - Remove prompt from myPrompts if it’s no longer a favorite
      final updatedMyPrompts = [...state.myPrompts];
      if (newFavoriteStatus && !updatedMyPrompts.contains(prompt)) {
        updatedMyPrompts.add(prompt);
      } else if (!newFavoriteStatus && updatedMyPrompts.contains(prompt)) {
        updatedMyPrompts.remove(prompt);
      }

      // 2) Update publicPrompts in memory
      final updatedPublicPrompts = [...state.publicPrompts];
      final publicIndex =
          updatedPublicPrompts.indexWhere((p) => p.id == prompt.id);
      if (publicIndex != -1) {
        updatedPublicPrompts[publicIndex] = prompt;
      }

      // 3) Write back to state: you can also update filteredPrompts if necessary
      state = state.copyWith(
        myPrompts: updatedMyPrompts,
        publicPrompts: updatedPublicPrompts,
      );

      // 4) Filter again if needed
      filterPrompts();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  Future<void> updatePrompt(
      Prompt prompt, String newTitle, String newContent) async {
    try {
      await _promptService.updatePrompt(
        id: prompt.id,
        title: newTitle,
        content: newContent,
      );

      prompt.title = newTitle;
      prompt.content = newContent;

      if (!mounted) return;
      state = state.copyWith(
        publicPrompts: [...state.publicPrompts],
        myPrompts: [...state.myPrompts],
      );
    } catch (e) {
      print('Error updating prompt: $e');
    }
  }

  void filterPrompts() {
    bool matchesQuery(Prompt prompt) {
      return state.searchQuery.isEmpty ||
          prompt.title
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase()) ||
          (prompt.description
                  ?.toLowerCase()
                  .contains(state.searchQuery.toLowerCase()) ??
              false);
    }

    if (state.selectedCategories.isEmpty ||
        state.selectedCategories.contains('All')) {
      state = state.copyWith(
        filteredPrompts: state.publicPrompts.where(matchesQuery).toList(),
      );
    } else {
      state = state.copyWith(
        filteredPrompts: state.publicPrompts.where((prompt) {
          final matchesCategory =
              state.selectedCategories.contains(prompt.category);
          return matchesCategory && matchesQuery(prompt);
        }).toList(),
      );
    }
  }

  void changeCategory(String category) {
    final updatedCategories = List<String>.from(state.selectedCategories);
    if (category == 'All') {
      updatedCategories
        ..clear()
        ..add('All');
    } else {
      if (updatedCategories.contains('All')) {
        updatedCategories.remove('All');
      }
      if (updatedCategories.contains(category)) {
        updatedCategories.remove(category);
      } else {
        updatedCategories.add(category);
      }
    }

    if (updatedCategories.isEmpty) {
      updatedCategories.add('All');
    }

    state = state.copyWith(selectedCategories: updatedCategories);
    filterPrompts();
  }

  void changeSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    filterPrompts();
  }

  void clearSelectedCategories() {
    state = state.copyWith(selectedCategories: ['All']);
    filterPrompts();
  }

  void togglePromptSelection() {
    state = state.copyWith(isMyPromptSelected: !state.isMyPromptSelected);
  }
}

final promptViewModelProvider =
    StateNotifierProvider<PromptNotifier, PromptLibraryState>((ref) {
  final promptService = ref.watch(promptServiceProvider);
  return PromptNotifier(promptService);
});
