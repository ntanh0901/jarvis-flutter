import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/views/prompts/api_prompts.dart';
import 'package:jarvis_application/ui/widgets/create_prompt_button.dart';
import 'package:jarvis_application/ui/widgets/prompts_switch_button.dart';
import 'package:jarvis_application/ui/widgets/search_text_field.dart';

import '../../../data/models/prompt.dart';
import '../../viewmodels/prompt_library_viewmodel.dart';
import '../../widgets/app_drawer.dart';

class PromptLibrary extends ConsumerStatefulWidget {
  const PromptLibrary({super.key});

  @override
  PromptLibraryState createState() => PromptLibraryState();
}

class PromptLibraryState extends ConsumerState<PromptLibrary> {
  @override
  void initState() {
    super.initState();
    signInAndFetchPrompts();
  }

  Future<void> signInAndFetchPrompts() async {
    var promptNotifier = ref.read(promptViewModelProvider.notifier);
    var state = ref.read(promptViewModelProvider);

    state = state.copyWith(isLoading: true);

    try {
      await ApiService.signIn();
      await promptNotifier.fetchMyPrompts();
      await promptNotifier.fetchPublicPrompts();
    } catch (e) {
      print('Error during sign in and fetch prompts: $e');
    } finally {
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promptViewModelProvider);
    final viewModel = ref.watch(promptViewModelProvider.notifier);
    final prompts = ref.watch(promptViewModelProvider).isMyPromptSelected
        ? state.myPrompts
        : state.filteredPrompts;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prompt Library'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CreatePromptButton(
                onPromptCreated: viewModel.refreshPrompts,
              ),
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
                    isMyPromptSelected: state.isMyPromptSelected,
                    onMyPromptSelected: () => ref
                        .read(promptViewModelProvider.notifier)
                        .togglePromptSelection(),
                    onPublicPromptSelected: () => ref
                        .read(promptViewModelProvider.notifier)
                        .togglePromptSelection(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (!state.isMyPromptSelected) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SearchTextField(
                    onSubmitted: (query) {
                      viewModel.changeSearchQuery(query);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: state.selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                    ),
                    items: state.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      viewModel.changeCategory(newValue!);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
              Expanded(
                child: state.isLoading
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
                            subtitle: state.isMyPromptSelected
                                ? null
                                : Text(prompt.description ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (state.isMyPromptSelected &&
                                    !(prompt.isPublic ?? false))
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xff697079),
                                    ),
                                    onPressed: () {
                                      showEditPromptDialog(prompt);
                                    },
                                  ),
                                if (prompt.isPublic == true) ...[
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
                                      ref
                                          .read(
                                              promptViewModelProvider.notifier)
                                          .toggleFavorite(prompt);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline,
                                        size: 20, color: Color(0xff697079)),
                                    onPressed: () {
                                      showPromptInfoDialog(prompt);
                                    },
                                  ),
                                ]
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
                ref
                    .read(promptViewModelProvider.notifier)
                    .deletePrompt(prompt.id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                ref.read(promptViewModelProvider.notifier).updatePrompt(
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
                              (prompt.isFavorite ?? false)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: (prompt.isFavorite ?? false)
                                  ? Colors.red
                                  : Colors.grey,
                              size: 20),
                          onPressed: () async {
                            await ref
                                .read(promptViewModelProvider.notifier)
                                .toggleFavorite(prompt);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.grey, size: 20),
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
}
