import 'package:flutter/material.dart';

// Services
import 'services/storage_service.dart';

// Screens
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/missions_screen.dart';
import 'ui/screens/city_screen.dart';
import 'ui/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(const HabitQuestApp());
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
      scaffoldBackgroundColor: const Color(0xFF0D0D12),

      primaryColor: const Color(0xFF00FFCC),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFCC),
        secondary: Color(0xFFFF00FF),
      ),

      fontFamily: 'Roboto',

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D12),
        elevation: 0,
        centerTitle: true,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A24),
        selectedItemColor: Color(0xFF00FFCC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A2A35)),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    MissionsScreen(),
    CityScreen(),
    ProfileScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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