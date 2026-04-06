import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  TITLE
              const Text(
                "Habit City",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF77E9),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Build your life like a strategy game.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              //  HEADLINE CARD
              _headlineCard(),

              const SizedBox(height: 30),

              const Text(
                "Quick Access",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              //  BUTTON GRID
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _navCard(context, Icons.dashboard, "Dashboard", 1),
                    _navCard(context, Icons.flag, "Missions", 2),
                    _navCard(context, Icons.location_city, "City", 3),
                    _navCard(context, Icons.person, "Profile", 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  HEADLINE CARD
  Widget _headlineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF77E9), Color(0xFF7AFBFF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Insight",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "You're 1 habit away from leveling up 🚀",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  //  NAV CARD
  Widget _navCard(
      BuildContext context, IconData icon, String label, int index) {
    return InkWell(
      onTap: () => onNavigate(index),
      borderRadius: BorderRadius.circular(16),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xFF141422),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFF77E9), size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}