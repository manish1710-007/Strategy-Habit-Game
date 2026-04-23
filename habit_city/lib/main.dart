import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import 'services/storage_service.dart';

// Core
import 'core/game_engine.dart';
import 'services/city_service.dart';
import 'core/game_engine.dart';

// Screens
import 'ui/screens/home_screen.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/missions_screen.dart';
import 'ui/screens/city_screen.dart';
import 'ui/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameEngine()),

        ChangeNotifierProxyProvider<GameEngine, CityProgressionService>(
          create: (context) =>
              CityProgressionService(context.read<GameEngine>()),
          update: (_, engine, service) {
              service ??= CityProgressionService(engine);
              return service;
          },
        ),
      ],
      child: const HabitQuestApp(),
    ),
  );
}

class HabitQuestApp extends StatelessWidget {
  const HabitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Control Panel',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const MainNavigation(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0B14),
      primaryColor: const Color(0xFFFF77E9),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF77E9),
        secondary: Color(0xFF7AFBFF),
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0B14),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF141422),
        selectedItemColor: Color(0xFFFF77E9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// 🧭 NAVIGATION
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _onTabChange(int index) {
    setState(() => _currentIndex = index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigate: switchTab),
          DashboardScreen(onNavigate: switchTab),
          MissionsScreen(onNavigate: switchTab),
          CityScreen(onNavigate: switchTab),
          ProfileScreen(onNavigate: switchTab),
        ],
      ),

      bottomNavigationBar: _currentIndex == 0
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex - 1,
              onTap: _onTabChange,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dash'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.flag), label: 'Missions'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.location_city), label: 'City'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
    );
  }
}