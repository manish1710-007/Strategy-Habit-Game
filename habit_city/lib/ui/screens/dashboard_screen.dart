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
  final Function(int) onNavigate;
  const DashboardScreen({super.key, required this.onNavigate});

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

  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  static const _black    = Color(0xFF050508);
  static const _void     = Color(0xFF0A0D14);
  static const _neonBlue = Color(0xFF00F0FF);
  static const _neonRed  = Color(0xFFFF003C);
  static const _white    = Color(0xFFE0E5FF);

  @override
  void initState() {
    super.initState();
    loadHabits();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOutSine),
    );
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

  void addHabit(String title) {
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      difficulty: 1,
      createdAt: DateTime.now(),
    );
    box.put(habit.id, habit.toMap());
    loadHabits();
  }

  void completeHabit(Habit habit, Offset position) {
    if (habit.completed) return;

    final appState = context.read<AppState>();
    final oldLevel = appState.completeHabit(
      difficulty: habit.difficulty,
      habitTag: "GENERAL", // wire habit.tag here when you add tags to Habit model
    );

    setState(() {
      habit.completed  = true;
      mood             = WaifuMood.happy;
      showParticle     = true;
      particlePosition = position;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          showParticle = false;
          mood         = WaifuMood.idle;
        });
      }
    });

    box.put(habit.id, habit.toMap());

    if (appState.level > oldLevel) {
      setState(() => mood = WaifuMood.excited);
      _showLevelUpDialog(appState.level);
    }
  }

  void deleteSelectedHabits() {
    for (final id in selectedIds) {
      box.delete(id);
    }
    setState(() {
      isSelectionMode = false;
      selectedIds.clear();
    });
    loadHabits();
  }

  void _showAddMissionDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: _black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _neonBlue, width: 1.5),
            boxShadow: [
              BoxShadow(color: _neonBlue.withOpacity(0.3), blurRadius: 20, spreadRadius: -2),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "NEW PROTOCOL",
                style: TextStyle(
                  color: _neonBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl,
                autofocus: true,
                style: const TextStyle(color: _white),
                cursorColor: _neonRed,
                decoration: InputDecoration(
                  hintText: "Enter mission designation...",
                  hintStyle: TextStyle(color: _white.withOpacity(0.3)),
                  filled: true,
                  fillColor: _void,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _neonBlue.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: _neonBlue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) {
                    addHabit(v.trim());
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL",
                        style: TextStyle(color: _neonRed, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final title = ctrl.text.trim();
                      if (title.isNotEmpty) {
                        addHabit(title);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_neonBlue, Color(0xFF0088AA)]),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: _neonBlue.withOpacity(0.4), blurRadius: 8),
                        ],
                      ),
                      child: const Text(
                        "INITIALIZE ⚡",
                        style: TextStyle(
                          color: _black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: _black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _neonBlue, width: 2.5),
            boxShadow: [
              BoxShadow(color: _neonBlue.withOpacity(0.4), blurRadius: 24, spreadRadius: 2),
              BoxShadow(color: _neonRed.withOpacity(0.3),  blurRadius: 40, spreadRadius: -4),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _neonRed.withOpacity(0.2),
                  border: Border.all(color: _neonRed),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: _neonRed.withOpacity(0.4), blurRadius: 12)],
                ),
                child: const Text(
                  "SYSTEM UPGRADE",
                  style: TextStyle(
                    color: _neonRed,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Level $level Achieved 🚀",
                style: const TextStyle(color: _white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Your districts are evolving...",
                style: TextStyle(
                    color: _neonBlue.withOpacity(0.7), fontSize: 12),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_neonBlue, Color(0xFF0088AA)]),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(color: _neonBlue.withOpacity(0.4), blurRadius: 14),
                    ],
                  ),
                  child: const Text(
                    "ACKNOWLEDGE ⚡",
                    style: TextStyle(
                      color: _black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: _black,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: _black.withOpacity(0.9),
            border: const Border(bottom: BorderSide(color: _neonBlue, width: 1.5)),
            boxShadow: [
              BoxShadow(color: _neonBlue.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Home button
                  GestureDetector(
                    onTap: () => widget.onNavigate(0),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _black,
                        border: Border.all(color: _neonRed, width: 1.5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _neonRed.withOpacity(0.5), blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.home_rounded, color: _neonRed, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "TERMINAL",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 4,
                    ),
                  ),
                  // Selection controls
                  if (isSelectionMode) ...[
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() {
                        selectedIds.length == habits.length
                            ? selectedIds.clear()
                            : selectedIds = habits.map((h) => h.id).toSet();
                      }),
                      child: Text(
                        selectedIds.length == habits.length
                            ? "DESELECT ALL"
                            : "SELECT ALL",
                        style: TextStyle(color: _neonBlue, fontSize: 11),
                      ),
                    ),
                    GestureDetector(
                      onTap: selectedIds.isNotEmpty ? deleteSelectedHabits : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _neonRed.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _neonRed.withOpacity(0.5)),
                        ),
                        child: Text(
                          "DELETE (${selectedIds.length})",
                          style: const TextStyle(
                            color: _neonRed,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() {
                        isSelectionMode = false;
                        selectedIds.clear();
                      }),
                      child: const Icon(Icons.close, color: _white, size: 20),
                    ),
                  ] else ...[
                    const Spacer(),
                    // Live XP badge in appbar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _neonBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: _neonBlue.withOpacity(0.4), width: 1),
                      ),
                      child: Text(
                        "LV.${appState.level} · ${appState.xp} XP",
                        style: const TextStyle(
                          color: _neonBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => isSelectionMode = true),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: _neonRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _neonRed.withOpacity(0.3), width: 1),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: _neonRed, size: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [_neonBlue, Color(0xFF0088AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: _neonBlue.withOpacity(0.6), blurRadius: 16, spreadRadius: 1),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddMissionDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: _black, size: 32),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CyberGridPainter())),

          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => Positioned.fill(
              child: CustomPaint(painter: _PulseBgPainter(t: _bgAnim.value)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //  Live header 
                _DashboardHeader(
                  energy: appState.energy,
                  xp: appState.xp,
                  level: appState.level,
                  currentXP: appState.currentXP,
                  xpProgress: appState.xpProgress,
                  rank: appState.rankLabel,
                  completedHabits: appState.completedHabits,
                  mood: mood,
                ),

                const SizedBox(height: 16),

                //  Habits 
                Expanded(
                  child: habits.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.terminal,
                                  color: _neonBlue.withOpacity(0.3), size: 56),
                              const SizedBox(height: 12),
                              Text(
                                "NO PROTOCOLS INITIALIZED",
                                style: TextStyle(
                                  color: _neonBlue.withOpacity(0.5),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            final isSelected = selectedIds.contains(habit.id);
                            return GestureDetector(
                              onLongPress: () => setState(() {
                                isSelectionMode = true;
                                selectedIds.add(habit.id);
                              }),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? _neonRed
                                          : habit.completed
                                              ? _neonBlue.withOpacity(0.2)
                                              : _neonBlue.withOpacity(0.4),
                                      width: isSelected ? 2 : 1.5,
                                    ),
                                    boxShadow: habit.completed
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: _neonBlue.withOpacity(0.08),
                                              blurRadius: 12,
                                            ),
                                          ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: HabitCard(
                                      habit: habit,
                                      onTapWithPosition: isSelectionMode
                                          ? (_) => setState(() {
                                                isSelected
                                                    ? selectedIds.remove(habit.id)
                                                    : selectedIds.add(habit.id);
                                              })
                                          : (pos) => completeHabit(habit, pos),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

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

//  Dashboard Header — reads live from AppState 
class _DashboardHeader extends StatelessWidget {
  final int energy;
  final int xp;
  final int level;
  final int currentXP;
  final double xpProgress;
  final String rank;
  final int completedHabits;
  final WaifuMood mood;

  static const _black    = Color(0xFF050508);
  static const _void     = Color(0xFF0A0D14);
  static const _neonBlue = Color(0xFF00F0FF);
  static const _neonRed  = Color(0xFFFF003C);
  static const _white    = Color(0xFFE0E5FF);

  const _DashboardHeader({
    required this.energy,
    required this.xp,
    required this.level,
    required this.currentXP,
    required this.xpProgress,
    required this.rank,
    required this.completedHabits,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _void,
        border: Border.all(color: _neonBlue.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 20),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeaderGridPainter())),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Row 1: Waifu + stats
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WaifuCharacter(mood: mood),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Level + rank
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _neonRed.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: _neonRed.withOpacity(0.6), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                        color: _neonRed.withOpacity(0.3),
                                        blurRadius: 8),
                                  ],
                                ),
                                child: Text(
                                  "LV.$level",
                                  style: const TextStyle(
                                    color: _neonRed,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                rank,
                                style: TextStyle(
                                  color: _neonBlue.withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // XP label
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "EXPERIENCE",
                                style: TextStyle(
                                  color: _white.withOpacity(0.35),
                                  fontSize: 9,
                                  letterSpacing: 2.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "$currentXP / 100 XP",
                                style: TextStyle(
                                  color: _neonBlue.withOpacity(0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          // Segmented XP bar
                          _SegmentedBar(value: xpProgress, color: _neonBlue),

                          const SizedBox(height: 10),

                          // Stat chips
                          Row(
                            children: [
                              _StatChip(
                                label: "ENERGY",
                                value: "$energy",
                                icon: Icons.bolt,
                                color: Colors.yellowAccent,
                              ),
                              const SizedBox(width: 8),
                              _StatChip(
                                label: "DONE",
                                value: "$completedHabits",
                                icon: Icons.check_circle_outline_rounded,
                                color: _neonBlue,
                              ),
                              const SizedBox(width: 8),
                              _StatChip(
                                label: "TOTAL XP",
                                value: "$xp",
                                icon: Icons.military_tech_rounded,
                                color: _neonRed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatChip(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  final double value;
  final Color color;
  const _SegmentedBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    const segments = 10;
    final filled = (value * segments).round();
    return Row(
      children: List.generate(segments, (i) {
        final active = i < filled;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < segments - 1 ? 3 : 0),
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: active ? color : color.withOpacity(0.08),
              boxShadow: active
                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

//  Painters 
class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF050508),
    );
    final p = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.04)
      ..strokeWidth = 1.0;
    const gap = 30.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PulseBgPainter extends CustomPainter {
  final double t;
  const _PulseBgPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.3,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF00F0FF).withOpacity(0.07 + 0.04 * t),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.85, size.height * 0.15),
          radius: size.width * 0.3,
        )),
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.85),
      size.width * 0.4,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFF003C).withOpacity(0.05 + 0.03 * t),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.1, size.height * 0.85),
          radius: size.width * 0.4,
        )),
    );
  }

  @override
  bool shouldRepaint(_PulseBgPainter old) => old.t != t;
}

class _HeaderGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.04)
      ..strokeWidth = 0.8;
    const gap = 20.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}