import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/cars/cars_screen.dart';
import 'package:odo24_mobile/features/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen.create()));

  static Widget create() => const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, index, _) => Scaffold(
        body: IndexedStack(index: index, children: [CarsScreen.create(), const ProfileScreen()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => _selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Авто'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Профиль'),
          ],
        ),
      ),
    );
  }
}
