import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_notifier.dart';
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
class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  late BuildContext _context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _context = context;
  }

  @override
  Widget build(BuildContext context) {
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
                context, Icons.email, 'Email compose', 4, selectedIndex, ref),
            _buildDrawerItem(
                context, Icons.logout, 'Sign out', 5, selectedIndex, ref),
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
        onTap: () async {
          ref.read(drawerProvider.notifier).selectItem(index);
          // Perform navigation directly
          switch (index) {
            case 0:
              _context.go('/chat');
              break;
            case 1:
              _context.go('/bot-list');
              break;
            case 2:
              _context.go('/knowledge-base');
              break;
            case 3:
              _context.go('/prompt-library');
              break;
            case 4:
              _context.go('/email-compose');
              break;
            case 5:
              await ref.read(authNotifierProvider.notifier).signOut();

              if (!mounted) return;

              _context.go('/sign-in');
              break;
          }
        });
  }
}
