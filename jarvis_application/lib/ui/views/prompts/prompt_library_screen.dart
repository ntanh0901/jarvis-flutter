import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/views/prompts/api_prompts.dart';
import 'package:jarvis_application/ui/widgets/create_prompt_button.dart';
import 'package:jarvis_application/ui/widgets/prompts_switch_button.dart';
import 'package:jarvis_application/ui/widgets/search_text_field.dart';

import '../../widgets/app_drawer.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  PromptLibraryState createState() => PromptLibraryState();
}

class PromptLibraryState extends State<PromptLibrary> {
  bool isMyPromptSelected = true;
  String selectedCategory = 'All';
  String searchQuery = '';
  List<String> categories = ['All'];
  List<Item> myPrompts = [];
  List<Item> publicPrompts = [];
  List<Item> filteredPrompts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    signInAndFetchPrompts();
  }

  Future<void> signInAndFetchPrompts() async {
    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.signIn();
      await fetchMyPrompts();
      await fetchPublicPrompts();
    } catch (e) {
      print('Error during sign in and fetch prompts: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMyPrompts() async {
    try {
      final privatePrompts = await ApiService.getPrompts(isPublic: false);
      final favoritePrompts = await ApiService.getPrompts(isPublic: true);
      setState(() {
        myPrompts = [
          ...privatePrompts,
          ...favoritePrompts.where((prompt) => prompt.isFavorite == true)
        ];
      });
      print('My Prompts set in state: ${myPrompts.length}');
    } catch (e) {
      print('Error fetching my prompts: $e');
    }
  }

  Future<void> fetchPublicPrompts() async {
    try {
      final fetchedPrompts = await ApiService.getPrompts(isPublic: true);
      final fetchedCategories = fetchedPrompts
          .map((prompt) => prompt.category)
          .where((category) => category != null)
          .toSet()
          .toList();
      setState(() {
        publicPrompts = fetchedPrompts;
        categories = ['All', ...fetchedCategories.cast<String>()];
        filteredPrompts = publicPrompts;
      });
      print('Public Prompts set in state: ${publicPrompts.length}');
    } catch (e) {
      print('Error fetching public prompts: $e');
    }
  }

  void filterPrompts() {
    setState(() {
      filteredPrompts = publicPrompts.where((prompt) {
        final matchesCategory =
            selectedCategory == 'All' || prompt.category == selectedCategory;
        final matchesQuery = searchQuery.isEmpty ||
            prompt.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (prompt.description
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false);
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  Future<void> toggleFavorite(Item prompt) async {
    try {
      if (prompt.isFavorite == true) {
        await ApiService.unfavoritePrompt(prompt.id);
      } else {
        await ApiService.favoritePrompt(prompt.id);
      }

      setState(() {
        prompt.isFavorite = !(prompt.isFavorite ?? false);

        // Update the prompt in myPrompts list
        if (prompt.isFavorite == true && !myPrompts.contains(prompt)) {
          myPrompts.add(prompt);
        } else if (prompt.isFavorite == false && myPrompts.contains(prompt)) {
          myPrompts.remove(prompt);
        }

        // Update the prompt in publicPrompts list
        final index = publicPrompts.indexWhere((p) => p.id == prompt.id);
        if (index != -1) {
          publicPrompts[index] = prompt;
        }

        // Update the filteredPrompts list if necessary
        filterPrompts();
      });
    } catch (e) {
      print('Error favoriting prompt: $e');
    }
  }

  Future<void> updatePrompt(
      Item prompt, String newTitle, String newContent) async {
    try {
      await ApiService.updatePrompt(
        id: prompt.id,
        title: newTitle,
        content: newContent,
      );
      setState(() {
        prompt.title = newTitle;
        prompt.content = newContent;
      });
    } catch (e) {
      print('Error updating prompt: $e');
    }
  }

  Future<void> deletePrompt(Item prompt) async {
    try {
      await ApiService.deletePrompt(prompt.id);
      setState(() {
        myPrompts.remove(prompt);
      });
    } catch (e) {
      print('Error deleting prompt: $e');
    }
  }

  void showEditPromptDialog(Item prompt) {
    final TextEditingController titleController =
        TextEditingController(text: prompt.title);
    final TextEditingController contentController =
        TextEditingController(text: prompt.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Prompt'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deletePrompt(prompt);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                updatePrompt(
                    prompt, titleController.text, contentController.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> refreshPrompts() async {
    await fetchMyPrompts();
    await fetchPublicPrompts();
  }

  void showPromptInfoDialog(Item prompt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(prompt.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Description: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: prompt.description ?? 'N/A'),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Category: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: prompt.category ?? 'N/A'),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Language: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: prompt.language ?? 'N/A'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Content:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: SingleChildScrollView(
                    child: Text(prompt.content),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Use Prompt'),
              onPressed: () {
                // Handle use prompt action
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prompts = isMyPromptSelected ? myPrompts : filteredPrompts;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prompt Library'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CreatePromptButton(),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: PromptsSwitchButton(
                  isMyPromptSelected: isMyPromptSelected,
                  onMyPromptSelected: () {
                    setState(() {
                      isMyPromptSelected = true;
                    });
                  },
                  onPublicPromptSelected: () {
                    setState(() {
                      isMyPromptSelected = false;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (!isMyPromptSelected) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SearchTextField(
                  onSubmitted: (query) {
                    setState(() {
                      searchQuery = query;
                      filterPrompts();
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      filterPrompts();
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: prompts.length,
                      itemBuilder: (context, index) {
                        final prompt = prompts[index];
                        return ListTile(
                          title: Text(prompt.title),
                          subtitle: isMyPromptSelected
                              ? null
                              : Text(prompt.description ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (isMyPromptSelected &&
                                  !(prompt.isPublic == true))
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showEditPromptDialog(prompt);
                                  },
                                ),
                              if (isMyPromptSelected && prompt.isPublic == true)
                                IconButton(
                                  icon: Icon(
                                    prompt.isFavorite == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: prompt.isFavorite == true
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () {
                                    toggleFavorite(prompt);
                                  },
                                ),
                              if (isMyPromptSelected && prompt.isPublic == true)
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showPromptInfoDialog(prompt);
                                  },
                                ),
                              if (!isMyPromptSelected)
                                IconButton(
                                  icon: Icon(
                                    prompt.isFavorite == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: prompt.isFavorite == true
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () {
                                    toggleFavorite(prompt);
                                  },
                                ),
                              if (!isMyPromptSelected)
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showPromptInfoDialog(prompt);
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
