import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_application/ui/views/prompts/api_prompts.dart';
import 'package:jarvis_application/ui/widgets/create_prompt_button.dart';
import 'package:jarvis_application/ui/widgets/prompts_switch_button.dart';
import 'package:jarvis_application/ui/widgets/search_text_field.dart';

import '../../../data/models/prompt.dart';
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
  List<Prompt> myPrompts = [];
  List<Prompt> publicPrompts = [];
  List<Prompt> filteredPrompts = [];
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

  Future<void> toggleFavorite(Prompt prompt) async {
    setState(() {
      prompt.isFavorite = !(prompt.isFavorite ?? false);
    });
    try {
      if (prompt.isFavorite == true) {
        await ApiService.unfavoritePrompt(prompt.id);
      } else {
        await ApiService.favoritePrompt(prompt.id);
      }
      setState(() {
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
      Prompt prompt, String newTitle, String newContent) async {
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

  Future<void> deletePrompt(Prompt prompt) async {
    try {
      await ApiService.deletePrompt(prompt.id);
      setState(() {
        myPrompts.remove(prompt);
      });
    } catch (e) {
      print('Error deleting prompt: $e');
    }
  }

  void showEditPromptDialog(Prompt prompt) {
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

  void showPromptInfoDialog(Prompt prompt) {
    final ScrollController scrollController = ScrollController();
    double verticalPadding = 16.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final maxDialogHeight = MediaQuery.of(context).size.height * 0.5;
        final minDialogWidth = MediaQuery.of(context).size.width * 0.7;

        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxDialogHeight,
              minWidth: minDialogWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        prompt.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            (prompt.isFavorite ??
                                    false) // Null check and fallback
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (prompt.isFavorite ?? false)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            await toggleFavorite(prompt);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                ListBody(
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
                    const SizedBox(height: 8.0),
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
                    const SizedBox(height: 8.0),
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
                  ],
                ),
                const SizedBox(height: 16.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Content:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy,
                        size: 15,
                        color: Color(0xff697079),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: prompt.content));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Content copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),

                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color(0xffF1F2F3),
                    ),
                    constraints: BoxConstraints(
                      minWidth: minDialogWidth,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        prompt.content,
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF6841EA),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                'Use Prompt',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Handle use prompt action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    scrollController.addListener(() {
      verticalPadding = scrollController.offset > 0 ? 0.0 : 16.0;
    });
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                            title: Text(prompt.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: isMyPromptSelected
                                ? null
                                : Text(prompt.description ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (isMyPromptSelected &&
                                    !(prompt.isPublic == true))
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xff697079),
                                    ),

                                    // size

                                    onPressed: () {
                                      showEditPromptDialog(prompt);
                                    },
                                  ),
                                if (isMyPromptSelected &&
                                    prompt.isPublic == true)
                                  IconButton(
                                    icon: Icon(
                                      prompt.isFavorite == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: prompt.isFavorite == true
                                          ? Colors.red
                                          : null,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      toggleFavorite(prompt);
                                    },
                                  ),
                                if (isMyPromptSelected &&
                                    prompt.isPublic == true)
                                  IconButton(
                                    icon: const Icon(Icons.info_outline,
                                        size: 20, color: Color(0xff697079)),
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
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      toggleFavorite(prompt);
                                    },
                                  ),
                                if (!isMyPromptSelected)
                                  IconButton(
                                    icon: const Icon(Icons.info_outline,
                                        size: 20, color: Color(0xff697079)),
                                    onPressed: () {
                                      showPromptInfoDialog(prompt);
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Divider(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
