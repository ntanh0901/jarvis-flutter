import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/prompt.dart';
import '../views/prompts/api_prompts.dart';

class PromptLibraryState {
  final bool isLoading;
  final bool isMyPromptSelected;
  final List<Prompt> myPrompts;
  final List<Prompt> publicPrompts;
  final List<Prompt> filteredPrompts;
  final List<String> selectedCategories; // Changed to a list of categories
  final String searchQuery;
  final List<String> categories;

  PromptLibraryState({
    this.isLoading = true,
    this.isMyPromptSelected = true,
    this.myPrompts = const [],
    this.publicPrompts = const [],
    this.filteredPrompts = const [],
    this.selectedCategories = const [], // Default to an empty list
    this.searchQuery = '',
    this.categories = const [],
  });

  PromptLibraryState copyWith({
    bool? isLoading,
    bool? isMyPromptSelected,
    List<Prompt>? myPrompts,
    List<Prompt>? publicPrompts,
    List<Prompt>? filteredPrompts,
    List<String>? selectedCategories, // Changed to a list
    String? searchQuery,
    List<String>? categories,
  }) {
    return PromptLibraryState(
      isLoading: isLoading ?? this.isLoading,
      isMyPromptSelected: isMyPromptSelected ?? this.isMyPromptSelected,
      myPrompts: myPrompts ?? this.myPrompts,
      publicPrompts: publicPrompts ?? this.publicPrompts,
      filteredPrompts: filteredPrompts ?? this.filteredPrompts,
      selectedCategories:
          selectedCategories ?? this.selectedCategories, // Handle list
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
    );
  }
}

class PromptNotifier extends StateNotifier<PromptLibraryState> {
  PromptNotifier() : super(PromptLibraryState());

  Future<void> signInAndFetchPrompts() async {
    state = state.copyWith(isLoading: true);

    try {
      await ApiService.signIn();
      await fetchMyPrompts();
      await fetchPublicPrompts();
    } catch (e) {
      print('Error during sign in and fetch prompts: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchMyPrompts() async {
    try {
      final privatePrompts = await ApiService.getPrompts(isPublic: false);
      final favoritePrompts = await ApiService.getPrompts(isPublic: true);
      state = state.copyWith(
        myPrompts: [
          ...privatePrompts,
          ...favoritePrompts.where((prompt) => prompt.isFavorite == true),
        ],
      );
    } catch (e) {
      print('Error fetching my prompts: $e');
    }
  }

  Future<void> fetchPublicPrompts() async {
    try {
      final fetchedPrompts = await ApiService.getPrompts(isPublic: true);
      final fetchedCategories = fetchedPrompts
          .map((prompt) => prompt.category)
          .whereType<String>()
          .toSet()
          .toList();
      state = state.copyWith(
        publicPrompts: fetchedPrompts,
        filteredPrompts: fetchedPrompts,
        categories: ['All', ...fetchedCategories],
        selectedCategories: ['All'],
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching public prompts: $e');
    }
  }

  Future<void> refreshPrompts() async {
    await fetchMyPrompts();
    await fetchPublicPrompts();
  }

  Future<void> deletePrompt(String id) async {
    try {
      await ApiService.deletePrompt(id);
    } catch (e) {
      print('Error deleting prompt: $e');
    }
  }

  Future<void> toggleFavorite(Prompt prompt) async {
    try {
      final newFavoriteStatus = !(prompt.isFavorite ?? false);
      if (newFavoriteStatus) {
        await ApiService.favoritePrompt(prompt.id);
      } else {
        await ApiService.unfavoritePrompt(prompt.id);
      }

      // Update the prompt locally
      prompt.isFavorite = newFavoriteStatus;

      refreshPrompts();
      state = state.copyWith(
        myPrompts: [...state.myPrompts],
        publicPrompts: [...state.publicPrompts],
      );
    } catch (e) {
      print('Error favoriting prompt: $e');
    }
  }

  Future<void> updatePrompt(
      Prompt prompt, String newTitle, String newContent) async {
    try {
      await ApiService.updatePrompt(
        id: prompt.id,
        title: newTitle,
        content: newContent,
      );

      // Update the prompt locally
      prompt.title = newTitle;
      prompt.content = newContent;

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

    if (state.selectedCategories.contains('All')) {
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
      updatedCategories.clear();
      updatedCategories.add('All');
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

// Define the Riverpod provider for the PromptNotifier
final promptViewModelProvider =
    StateNotifierProvider<PromptNotifier, PromptLibraryState>((ref) {
  return PromptNotifier();
});
