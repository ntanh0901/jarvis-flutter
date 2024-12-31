import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/widgets/create_prompt_button.dart';
import 'package:jarvis_application/ui/widgets/search_text_field.dart';

import '../../../data/models/prompt.dart';
import '../../viewmodels/prompt_library_viewmodel.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/chips_widget.dart';
import '../../widgets/segment_toggle_button.dart';

class PromptLibrary extends ConsumerStatefulWidget {
  const PromptLibrary({super.key});

  @override
  PromptLibraryState createState() => PromptLibraryState();
}

class PromptLibraryState extends ConsumerState<PromptLibrary> {
  @override
  void initState() {
    super.initState();
    ref.read(promptViewModelProvider.notifier).init();
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
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            title: const Text(
              'Prompt Library',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CreatePromptButton(
                  onPromptCreated: viewModel.refreshPrompts,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                color: Colors.grey[200],
                height: 1,
              ),
            )),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SegmentToggleButton(
                      initialSegment: state.isMyPromptSelected
                          ? 'my_prompt'
                          : 'public_prompt',
                      segments: const {
                        'my_prompt': 'My Prompt',
                        'public_prompt': 'Public Prompt',
                      },
                      onSegmentChanged: (selectedSegment) {
                        ref
                            .read(promptViewModelProvider.notifier)
                            .togglePromptSelection();
                      },
                    )),
              ),
              const SizedBox(height: 16.0),
              if (!state.isMyPromptSelected) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SearchTextField(
                    id: 'searchPrompt',
                    onChange: (query) {
                      viewModel.changeSearchQuery(query);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Chips(
                  items: state.categories,
                  selectedItems: state.selectedCategories,
                  onItemSelected: viewModel.changeCategory,
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
                            key: ValueKey(prompt.id),
                            title: Text(prompt.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: state.isMyPromptSelected
                                ? null
                                : Text(
                                    prompt.description ?? '',
                                    style: const TextStyle(
                                        color: Color(0xFF89929D)),
                                  ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (state.isMyPromptSelected &&
                                    !(prompt.isPublic ?? false))
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Color(0xff697079),
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(
                                              promptViewModelProvider.notifier)
                                          .deletePrompt(prompt.id);
                                    },
                                  ),
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
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    style: const ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
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
                          child: Divider(
                            thickness: 0.2,
                          ),
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
        final double minDialogWidth = MediaQuery.of(context).size.width * 0.8;

        return AlertDialog(
          iconPadding: const EdgeInsets.only(top: 10, right: 10),
          icon: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close, color: Colors.grey, size: 20),
            ),
          ),
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minDialogWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Edit Prompt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter title',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Prompt',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color(0xffF1F2F3),
                    ),
                    child: TextField(
                      controller: contentController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF1F5F9),
                        contentPadding: EdgeInsets.all(16.0),
                        border: InputBorder.none,
                        hintText: 'Enter prompt details',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF6841EA),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16.0,
              ),
              label: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                ref.read(promptViewModelProvider.notifier).updatePrompt(
                    prompt, titleController.text, contentController.text);
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          icon: Icon(
                            (prompt.isFavorite ?? false)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (prompt.isFavorite ?? false)
                                ? Colors.red
                                : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () async {
                            await ref
                                .read(promptViewModelProvider.notifier)
                                .toggleFavorite(prompt);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        const SizedBox(width: 15.0),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
              icon: const Icon(
                CupertinoIcons.conversation_bubble,
                color: Colors.white,
                size: 20.0,
              ),
              label: const Text(
                'Use Prompt',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );

    scrollController.addListener(() {
      verticalPadding = scrollController.offset > 0 ? 0.0 : 16.0;
    });
  }
}
