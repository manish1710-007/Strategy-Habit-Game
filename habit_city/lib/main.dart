import 'package:flutter/material.dart';

// Services
import 'services/storage_service.dart';

// Screens
import 'ui/screens/home_screen.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/missions_screen.dart';
import 'ui/screens/city_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'core/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
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

//  MAIN NAVIGATION
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  //  Navigation handler
  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabChange(int index) {
    // Bottom nav maps to:
    // 0 -> Dashboard (Index 1 in stack)
    // 1 -> Missions   (Index 2 in stack)
    // 2 -> City       (Index 3 in stack)
    // 3 -> Profile    (Index 4 in stack)
    setState(() {
      _currentIndex = index + 1; // 👈 shift because Home is index 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Home
          HomeScreen(onNavigate: switchTab),
          
          // Index 1: Dashboard
          DashboardScreen(onNavigate: switchTab), 
          
          // Index 2: Missions
          MissionsScreen(onNavigate: switchTab),
          
          // Index 3: City
          CityScreen(onNavigate: switchTab),
          
          // Index 4: Profile
          ProfileScreen(onNavigate: switchTab),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // If we are on Home (index 0), select the first tab (Dashboard) visually,
        // otherwise select the current tab - 1.
        currentIndex: _currentIndex == 0 ? 0 : _currentIndex - 1,
        onTap: _onTabChange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Missions'),
          BottomNavigationBarItem(icon: Icon(Icons.location_city), label: 'City'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}