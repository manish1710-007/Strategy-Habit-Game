import 'package:flutter/material.dart';
import '../../models/habit.dart';
import '../../services/storage_service.dart';
import '../widgets/habit_card.dart';
import 'package:uuid/uuid.dart';
import '../widgets/particle_burst.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final box = StorageService.getHabitBox();
  bool showParticle = false;
  Offset particlePosition = Offset.zero;

  List<Habit> habits = [];

  int energy = 100;
  int xp = 0;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  void loadHabits() {
    final data = box.values.toList();
    setState(() {
      habits = data
          .map((e) => Habit.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  void addHabit() {
    final habit = Habit(
      id: const Uuid().v4(),
      title: "New Mission",
      difficulty: 1,
      createdAt: DateTime.now(),
    );

    box.put(habit.id, habit.toMap());
    loadHabits();
  }

  void completeHabit(Habit habit, Offset position) async {
    if (habit.completed) return;

    final gainedXP = habit.difficulty * 10;

    setState(() {
      habit.completed = true;
      xp += gainedXP;
      energy += habit.difficulty * 5;
      showParticle = true; //  Trigger the particle animation
      particlePosition = position;
    });

    // Hide after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => showParticle = false);
      }
    });

    box.put(habit.id, habit.toMap());

    final oldLevel = (xp - gainedXP) ~/ 100 + 1;
    final newLevel = xp ~/ 100 + 1;

    if (newLevel > oldLevel) {
      _showLevelUpDialog(newLevel);
    }
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          title: const Text("LEVEL UP!", style: TextStyle(color: Colors.white)),
          content: Text(
            "You reached Level $level",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Nice!", style: TextStyle(color: Color(0XFF00FFCC))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),
      // UPDATED BODY WRAPPED IN STACK
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // RESOURCE BAR SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _resourceChip("⚡ Energy", energy, Colors.yellowAccent),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _xpBar(xp),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // HABITS LIST SECTION
                Expanded(
                  child: habits.isEmpty
                      ? const Center(child: Text("No missions yet"))
                      : ListView.builder(
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            return HabitCard(
                              habit: habit,
                              onTapWithPosition: (pos) => completeHabit(habit, pos),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          //  PARTICLE OVERLAY
          if (showParticle)
            Positioned(
              left: particlePosition.dx - 20,
              top: particlePosition.dy - 80,
              child: const ParticleBurst(),
            ),
        ],
      ),
    );
  }

  Widget _resourceChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _xpBar(int totalXP) {
    final level = totalXP ~/ 100 + 1;
    final currentXP = totalXP % 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Level $level",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: currentXP / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF00FFCC)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$currentXP / 100 XP",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}