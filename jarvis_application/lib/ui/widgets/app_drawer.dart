import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_logo.dart';

// DrawerCubit class
class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0);

  void selectItem(int index) => emit(index);
}

// DrawerNotifier class and drawerProvider
class DrawerNotifier extends StateNotifier<int> {
  DrawerNotifier() : super(0);

  void selectItem(int index) {
    state = index;
  }
}

final drawerProvider = StateNotifierProvider<DrawerNotifier, int>((ref) {
  return DrawerNotifier();
});

// AppDrawer widget
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(drawerProvider);

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 100,
              width: double.infinity,
              child: DrawerHeader(
                child: Row(
                  children: [
                    AppLogo(size: 15),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(
                context, Icons.chat, 'Chat', 0, selectedIndex, ref),
            _buildDrawerItem(
                context, Icons.list, 'Bot List', 1, selectedIndex, ref),
            _buildDrawerItem(context, Icons.book, 'KB', 2, selectedIndex, ref),
            _buildDrawerItem(
                context, Icons.lightbulb, 'Prompts', 3, selectedIndex, ref),
            _buildDrawerItem(
                context, Icons.email, 'Email', 4, selectedIndex, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      int index, int selectedIndex, WidgetRef ref) {
    final bool isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.blue[700] : Colors.transparent,
      onTap: () {
        ref.read(drawerProvider.notifier).selectItem(index);
        Navigator.pop(context); // Close the drawer
        // Navigate to the corresponding route
        switch (index) {
          case 0:
            context.go('/chat');
            break;
          case 1:
            context.go('/bot-list');
            break;
          case 2:
            context.go('/knowledge-base');
            break;
          case 3:
            context.go('/prompt-library');
            break;
          case 4:
            context.go('/email-compose');
            break;
        }
      },
    );
  }
}
