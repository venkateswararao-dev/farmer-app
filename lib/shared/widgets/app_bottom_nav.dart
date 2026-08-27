import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/ai-assistant')) return 1;
    if (location.startsWith('/disease-detection')) return 2;
    if (location.startsWith('/weather')) return 3;
    if (location.startsWith('/market-prices')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/ai-assistant');
        break;
      case 2:
        context.go('/disease-detection');
        break;
      case 3:
        context.go('/weather');
        break;
      case 4:
        context.go('/market-prices');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 64,
          indicatorColor: AppColors.primaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              );
            }
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 22, color: AppColors.primary);
            }
            return const IconThemeData(size: 22, color: AppColors.textSecondary);
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: AppColors.surface,
          elevation: 4,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: s.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.psychology_outlined),
              selectedIcon: const Icon(Icons.psychology),
              label: s.aiAssistant,
            ),
            NavigationDestination(
              icon: const Icon(Icons.camera_alt_outlined),
              selectedIcon: const Icon(Icons.camera_alt),
              label: s.cropDoctor,
            ),
            NavigationDestination(
              icon: const Icon(Icons.cloud_outlined),
              selectedIcon: const Icon(Icons.cloud),
              label: s.weather,
            ),
            NavigationDestination(
              icon: const Icon(Icons.currency_rupee),
              selectedIcon: const Icon(Icons.currency_rupee),
              label: s.marketPrices,
            ),
          ],
        ),
      ),
    );
  }
}
