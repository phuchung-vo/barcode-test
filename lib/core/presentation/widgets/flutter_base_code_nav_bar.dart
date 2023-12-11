// ignore_for_file: invalid_use_of_protected_member

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/core/presentation/widgets/hidable.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AppNavBar extends HookWidget {
  const AppNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Hidable(
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: <Widget>[
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: context.l10n.common_home.capitalize(),
              ),
              const NavigationDestination(
                icon: Icon(Icons.camera_alt_outlined),
                selectedIcon: Icon(Icons.camera_alt),
                label: 'Demo',
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle_outlined),
                selectedIcon: const Icon(Icons.account_circle),
                label: context.l10n.common_profile.capitalize(),
              ),
            ],
            onDestinationSelected: (int index) => _onItemTapped(context, index),
          ),
        ),
      );

  void _onItemTapped(
    BuildContext context,
    int index,
  ) {
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }
}
