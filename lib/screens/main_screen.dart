import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../providers/navigation_provider.dart';
import 'home_screen.dart';
import 'enquete_form_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const EnqueteFormScreen(),
      const MapScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: StylishBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).state = index;
        },
        option: AnimatedBarOptions(
          iconStyle: IconStyle.animated,
          barAnimation: BarAnimation.liquid,
        ),
        hasNotch: true,
        items: [
          BottomBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            selectedColor: const Color(0xFFE1660B),
            title: const Text('Accueil'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.description_outlined),
            selectedIcon: const Icon(Icons.description),
            selectedColor: const Color(0xFFE1660B),
            title: const Text('Formulaire'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            selectedColor: const Color(0xFFE1660B),
            title: const Text('Carte'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            selectedColor: const Color(0xFFE1660B),
            title: const Text('Paramètres'),
          ),
        ],
      ),
    );
  }
}
