import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/habit.dart';
import '../../services/storage_service.dart';
import '../../core/app_state.dart';

import '../widgets/habit_card.dart';
import '../widgets/particle_burst.dart';
import '../widgets/waifu_character.dart';

import 'package:uuid/uuid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final box = StorageService.getHabitBox();

  List<Habit> habits = [];

  bool showParticle = false;
  Offset particlePosition = Offset.zero;

  WaifuMood mood = WaifuMood.idle;

  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  static const _black = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple = Color(0xFF7B2FBE);
  static const _red = Color(0xFFCC1C3A);
  static const _liteBlue = Color(0xFF6EC6F5);

  @override
  void initState() {
    super.initState();
    loadHabits();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
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

  void completeHabit(Habit habit, Offset position) {
    if (habit.completed) return;

    final appState = context.read<AppState>();
    final gainedXP = habit.difficulty * 10;
    final oldXP = appState.xp;

    setState(() {
      habit.completed = true;
      mood = WaifuMood.happy;
      showParticle = true;
      particlePosition = position;
    });

    //  Global updates
    appState.addXP(gainedXP);
    appState.addEnergy(habit.difficulty * 5);

    //  Reset animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          showParticle = false;
          mood = WaifuMood.idle;
        });
      }
    });

    //  Save habit
    box.put(habit.id, habit.toMap());

    //  Level up check
    final newXP = appState.xp;
    final oldLevel = (oldXP ~/ 100) + 1;
    final newLevel = (newXP ~/ 100) + 1;

    if (newLevel > oldLevel) {
      setState(() => mood = WaifuMood.excited);
      _showLevelUpDialog(newLevel);
    }
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _black,
        title: const Text("LEVEL UP!",
            style: TextStyle(color: Colors.white)),
        content: Text(
          "You reached Level $level 🚀",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nice!",
                style: TextStyle(color: Colors.pinkAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: _black,

      appBar: AppBar(
        title: const Text("MISSION BOARD"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),

      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) =>
                Container(color: _deepPurple.withOpacity(0.2)),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //  HEADER
                _DashboardHeader(
                  energy: appState.energy,
                  xp: appState.xp,
                  mood: mood,
                ),

                const SizedBox(height: 16),

                //  HABITS
                Expanded(
                  child: habits.isEmpty
                      ? const Center(child: Text("No missions yet"))
                      : ListView.builder(
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            return HabitCard(
                              habit: habit,
                              onTapWithPosition: (pos) =>
                                  completeHabit(habit, pos),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // PARTICLE
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
}

class _DashboardHeader extends StatelessWidget {
  final int energy;
  final int xp;
  final WaifuMood mood;

  const _DashboardHeader({
    required this.energy,
    required this.xp,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final level = (xp ~/ 100) + 1;
    final currentXP = xp % 100;

    return Column(
      children: [
        WaifuCharacter(mood: mood),
        const SizedBox(height: 10),

        Text("Level $level",
            style: const TextStyle(color: Colors.white)),

        LinearProgressIndicator(
          value: currentXP / 100,
        ),

        const SizedBox(height: 6),

        Text("$currentXP / 100 XP",
            style: const TextStyle(color: Colors.grey)),

        const SizedBox(height: 10),

        Text("⚡ Energy: $energy",
            style: const TextStyle(color: Colors.yellowAccent)),
      ],
    );
  }
}