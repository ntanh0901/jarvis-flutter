import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/prompt.dart';
import '../views/prompts/api_prompts.dart';

// Define the state model for managing prompts
class PromptState {
  final bool isLoading;
  final List<Prompt> myPrompts;
  final List<Prompt> publicPrompts;
  final List<Prompt> filteredPrompts;
  final String selectedCategory;
  final String searchQuery;

  PromptState({
    required this.isLoading,
    required this.myPrompts,
    required this.publicPrompts,
    required this.filteredPrompts,
    required this.selectedCategory,
    required this.searchQuery,
  });

  // Copy constructor to easily create a new state based on the old one
  PromptState copyWith({
    bool? isLoading,
    List<Prompt>? myPrompts,
    List<Prompt>? publicPrompts,
    List<Prompt>? filteredPrompts,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return PromptState(
      isLoading: isLoading ?? this.isLoading,
      myPrompts: myPrompts ?? this.myPrompts,
      publicPrompts: publicPrompts ?? this.publicPrompts,
      filteredPrompts: filteredPrompts ?? this.filteredPrompts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Define the Riverpod provider for the view model
final promptViewModelProvider =
    StateNotifierProvider<PromptViewModel, PromptState>((ref) {
  return PromptViewModel();
});

class PromptViewModel extends StateNotifier<PromptState> {
  PromptViewModel()
      : super(PromptState(
          isLoading: true,
          myPrompts: [],
          publicPrompts: [],
          filteredPrompts: [],
          selectedCategory: 'All',
          searchQuery: '',
        ));

  // Fetch user-specific prompts
  Future<void> fetchMyPrompts() async {
    try {
      final privatePrompts = await ApiService.getPrompts(isPublic: false);
      final favoritePrompts = await ApiService.getPrompts(isPublic: true);
      state = state.copyWith(
        myPrompts: [
          ...privatePrompts,
          ...favoritePrompts.where((prompt) => prompt.isFavorite == true)
        ],
      );
    } catch (e) {
      print('Error fetching my prompts: $e');
    }
  }

  // Fetch public prompts
  Future<void> fetchPublicPrompts() async {
    try {
      final fetchedPrompts = await ApiService.getPrompts(isPublic: true);
      state = state.copyWith(
        publicPrompts: fetchedPrompts,
        filteredPrompts: fetchedPrompts,
        selectedCategory: 'All',
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching public prompts: $e');
    }
  }

  // Toggle favorite state
  Future<void> toggleFavorite(Prompt prompt) async {
    try {
      final newFavoriteStatus = !(prompt.isFavorite ?? false);
      if (newFavoriteStatus) {
        await ApiService.favoritePrompt(prompt.id);
      } else {
        await ApiService.unfavoritePrompt(prompt.id);
      }

      prompt.isFavorite = newFavoriteStatus;

      // Update the state to reflect the favorite toggle
      state = state.copyWith(
        myPrompts: [...state.myPrompts],
        publicPrompts: [...state.publicPrompts],
      );
    } catch (e) {
      print('Error favoriting prompt: $e');
    }
  }

  // Update prompt details
  Future<void> updatePrompt(
      Prompt prompt, String newTitle, String newContent) async {
    try {
      await ApiService.updatePrompt(
        id: prompt.id,
        title: newTitle,
        content: newContent,
      );
      prompt.title = newTitle;
      prompt.content = newContent;

      // Update the state
      state = state.copyWith(
        publicPrompts: [...state.publicPrompts],
        myPrompts: [...state.myPrompts],
      );
    } catch (e) {
      print('Error updating prompt: $e');
    }
  }

  // Filter prompts based on category and search query
  void filterPrompts() {
    state = state.copyWith(
      filteredPrompts: state.publicPrompts.where((prompt) {
        final matchesCategory = state.selectedCategory == 'All' ||
            prompt.category == state.selectedCategory;
        final matchesQuery = state.searchQuery.isEmpty ||
            prompt.title
                .toLowerCase()
                .contains(state.searchQuery.toLowerCase()) ||
            (prompt.description
                    ?.toLowerCase()
                    .contains(state.searchQuery.toLowerCase()) ??
                false);
        return matchesCategory && matchesQuery;
      }).toList(),
    );
  }

  // Change category filter
  void changeCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    filterPrompts();
  }

  // Change search query
  void changeSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    filterPrompts();
  }
}
