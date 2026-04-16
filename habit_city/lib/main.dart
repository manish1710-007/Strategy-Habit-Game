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
    // 0 -> Dashboard
    // 1 -> Missions
    // 2 -> City
    // 3 -> Profile
    // IndexedStack indices: 0: Home, 1: Dashboard, 2: Missions, 3: City, 4: Profile
    setState(() {
      _currentIndex = index + 1; // shift because Home is index 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            gifAssetPath: 'assets/hatsune miku .gif',
            onNavigate: switchTab,
          ),// Index 0
          DashboardScreen(onNavigate: switchTab), // Index 1
          MissionsScreen(onNavigate: switchTab),  // Index 2
          CityScreen(onNavigate: switchTab),      // Index 3
          ProfileScreen(onNavigate: switchTab),   // Index 4
        ],
      ),
      
      //  CONDITIONAL BOTTOM BAR 
      // Hide the bottom bar if we are on HomeScreen (index 0)
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