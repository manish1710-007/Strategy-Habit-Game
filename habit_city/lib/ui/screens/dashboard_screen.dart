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

  // Selection state
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  //Retro Futuristic Palette
  static const _black    = Color(0xFF050508); // Deep dark void
  static const _void     = Color(0xFF0A0D14); // Slightly elevated dark
  static const _neonBlue = Color(0xFF00F0FF); // Cyber Cyan
  static const _neonRed  = Color(0xFFFF003C); // Synthwave Red
  static const _white    = Color(0xFFE0E5FF); // Crisp digital white

  @override
  void initState() {
    super.initState();
    loadHabits();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOutSine)
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

  // Accepts a custom title from the dialog
  void addHabit(String title) {
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      difficulty: 1, // Can make this selectable later!
      createdAt: DateTime.now(),
    );
    box.put(habit.id, habit.toMap());
    loadHabits();
  }

  void completeHabit(Habit habit, Offset position) {
    if (habit.completed) return;

    final appState = context.read<AppState>();
    final gainedXP = habit.difficulty * 10;
    final oldXP    = appState.xp;

    setState(() {
      habit.completed  = true;
      mood             = WaifuMood.happy;
      showParticle     = true;
      particlePosition = position;
    });

    appState.addXP(gainedXP);
    appState.addEnergy(habit.difficulty * 5);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          showParticle = false;
          mood         = WaifuMood.idle;
        });
      }
    });

    box.put(habit.id, habit.toMap());

    final newXP    = appState.xp;
    final oldLevel = (oldXP ~/ 100) + 1;
    final newLevel = (newXP ~/ 100) + 1;

    if (newLevel > oldLevel) {
      setState(() => mood = WaifuMood.excited);
      _showLevelUpDialog(newLevel);
    }
  }

  void deleteSelectedHabits() {
    for (var id in selectedIds) {
      box.delete(id);
    }
    setState(() {
      isSelectionMode = false;
      selectedIds.clear();
    });
    loadHabits();
  }

  // The Cyberpunk Input Dialog
  void _showAddMissionDialog() {
    final TextEditingController titleController = TextEditingController();

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
                controller: titleController,
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
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    addHabit(value.trim());
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
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: _neonRed, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final title = titleController.text.trim();
                      if (title.isNotEmpty) {
                        addHabit(title);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_neonBlue, Color(0xFF0088AA)]),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.4), blurRadius: 8)],
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
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_neonBlue, Color(0xFF0088AA)]),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.4), blurRadius: 14)],
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

      // AppBar 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: _black.withOpacity(0.9),
            border: const Border(bottom: BorderSide(color: _neonBlue, width: 1.5)),
            boxShadow: [
              BoxShadow(color: _neonBlue.withOpacity(0.2), blurRadius: 15, spreadRadius: 1)
            ]
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

                  // Selection & Deletion Controls
                  if (isSelectionMode) ...[
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (selectedIds.length == habits.length) {
                            selectedIds.clear();
                          } else {
                            selectedIds = habits.map((h) => h.id).toSet();
                          }
                        });
                      },
                      child: Text(
                        selectedIds.length == habits.length ? "DESELECT ALL" : "SELECT ALL",
                        style: const TextStyle(color: _neonBlue, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: _neonRed),
                      onPressed: selectedIds.isEmpty ? null : deleteSelectedHabits,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: _white),
                      onPressed: () => setState(() {
                        isSelectionMode = false;
                        selectedIds.clear();
                      }),
                    ),
                  ] else ...[
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => isSelectionMode = true),
                      child: const Text(
                        "SELECT",
                        style: TextStyle(color: _neonBlue, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),

      // Calls the Custom Input Dialog
      floatingActionButton: isSelectionMode ? null : Container(
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
          onPressed: _showAddMissionDialog, // Changed this line
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: _black, size: 32),
        ),
      ),

      // Body 
      body: Stack(
        children: [
          // Animated Retro Grid Background
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => _RetroWaveBackground(t: _bgAnim.value),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Cinematic header 
                _DashboardHeader(
                  energy: appState.energy,
                  xp: appState.xp,
                  mood: mood,
                ),

                const SizedBox(height: 16),

                // Habits list 
                Expanded(
                  child: habits.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.memory, color: _neonBlue.withOpacity(0.3), size: 56),
                              const SizedBox(height: 12),
                              const Text(
                                "NO ACTIVE PROTOCOLS",
                                style: TextStyle(
                                  color: _neonBlue,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                  fontSize: 14,
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

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onLongPress: () {
                                  if (!isSelectionMode) {
                                    setState(() {
                                      isSelectionMode = true;
                                      selectedIds.add(habit.id);
                                    });
                                  }
                                },
                                onTap: () {
                                  if (isSelectionMode) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIds.remove(habit.id);
                                      } else {
                                        selectedIds.add(habit.id);
                                      }
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: isSelected ? _neonRed.withOpacity(0.1) : Colors.transparent,
                                    border: Border.all(
                                      color: isSelectionMode
                                          ? (isSelected ? _neonRed : _void)
                                          : (habit.completed ? _neonBlue.withOpacity(0.2) : _neonBlue.withOpacity(0.7)),
                                      width: isSelected ? 2.0 : 1.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [BoxShadow(color: _neonRed.withOpacity(0.3), blurRadius: 15)]
                                        : (habit.completed ? [] : [BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 12)]),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: IgnorePointer(
                                      // Disable inner taps if in selection mode
                                      ignoring: isSelectionMode,
                                      child: HabitCard(
                                        habit: habit,
                                        onTapWithPosition: (pos) => completeHabit(habit, pos),
                                      ),
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

          // Particle overlay 
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

//  Dashboard Header 
class _DashboardHeader extends StatelessWidget {
  final int energy;
  final int xp;
  final WaifuMood mood;

  const _DashboardHeader({
    required this.energy,
    required this.xp,
    required this.mood,
  });

  static const _void     = Color(0xFF0A0D14);
  static const _neonBlue = Color(0xFF00F0FF);
  static const _neonRed  = Color(0xFFFF003C);
  static const _white    = Color(0xFFE0E5FF);

  @override
  Widget build(BuildContext context) {
    final level    = xp ~/ 100 + 1;
    final current  = xp % 100;

    return Container(
      height: 160,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: _void,
        border: Border.all(color: _neonBlue.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 28, spreadRadius: -2),
          BoxShadow(color: _neonRed.withOpacity(0.05),  blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          // Blue right aura
          Positioned(
            right: -40, top: -40, bottom: -40,
            width: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerRight,
                  colors: [_neonBlue.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),

          // Red bottom-left bleed
          Positioned(
            left: -40, bottom: -40,
            width: 160, height: 160,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  _neonRed.withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LEFT: Waifu + energy chip 
                SizedBox(
                  width: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: WaifuCharacter(mood: mood),
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: _EnergyChip(energy: energy),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Gradient divider
                Container(
                  width: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _neonBlue.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // RIGHT: Stats 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Level row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _neonRed.withOpacity(0.15),
                              border: Border.all(color: _neonRed),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(color: _neonRed.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            child: Text(
                              "LV.$level",
                              style: const TextStyle(
                                color: _neonRed,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _rankLabel(level),
                            style: TextStyle(
                              color: _neonBlue.withOpacity(0.85),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // XP label row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "EXPERIENCE",
                            style: TextStyle(
                              color: _white.withOpacity(0.5),
                              fontSize: 9,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "$current / 100 XP",
                            style: const TextStyle(
                              color: _neonBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Segmented XP bar
                      _SegmentedXPBar(value: current / 100),

                      const SizedBox(height: 14),

                      // Stat pills
                      Row(
                        children: [
                          _MiniStatPill(
                            icon: Icons.local_fire_department_rounded,
                            label: "STREAK",
                            value: "7d",
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 8),
                          _MiniStatPill(
                            icon: Icons.military_tech_rounded,
                            label: "TOTAL XP",
                            value: "$xp",
                            color: _neonBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _rankLabel(int level) {
    if (level < 3)  return "ROOKIE";
    if (level < 6)  return "HUNTER";
    if (level < 10) return "VETERAN";
    return "LEGEND";
  }
}

// Energy chip 
class _EnergyChip extends StatelessWidget {
  final int energy;
  const _EnergyChip({required this.energy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF050508).withOpacity(0.8),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00F0FF).withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("⚡", style: TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          Text(
            "$energy",
            style: const TextStyle(
              color: Color(0xFF00F0FF),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

//  Segmented XP bar 
class _SegmentedXPBar extends StatelessWidget {
  final double value;
  const _SegmentedXPBar({required this.value});

  static const _neonBlue = Color(0xFF00F0FF);
  static const _neonDark = Color(0xFF005577);

  @override
  Widget build(BuildContext context) {
    const segments = 10;
    final filled   = (value * segments).round();

    return Row(
      children: List.generate(segments, (i) {
        final active = i < filled;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < segments - 1 ? 3 : 0),
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: active
                  ? Color.lerp(_neonDark, _neonBlue, i / segments)
                  : Colors.white.withOpacity(0.05),
              boxShadow: active
                  ? [BoxShadow(color: _neonBlue.withOpacity(0.5), blurRadius: 6)]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

// Mini stat pill 
class _MiniStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MiniStatPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Smooth Retro Wave Background (Replaces Comic BG)
class _RetroWaveBackground extends StatelessWidget {
  final double t;
  const _RetroWaveBackground({required this.t});

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: CustomPaint(painter: _RetroWavePainter(t: t)));
}

class _RetroWavePainter extends CustomPainter {
  final double t;
  const _RetroWavePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    // Solid Void Base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height), 
      Paint()..color = const Color(0xFF050508)
    );

    // Glowing Top Blue Horizon
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.4),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF00F0FF).withOpacity(0.1 + 0.05 * t),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4))
    );

    // Cyber Grid Perspective
    final gridPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final horizonY = size.height * 0.4;
    final cx = size.width / 2;

    // Vertical Perspective Lines
    for (int i = -10; i <= 10; i++) {
      final startX = cx + (i * 20);
      final endX = cx + (i * 100);
      canvas.drawLine(
        Offset(startX, horizonY), 
        Offset(endX, size.height), 
        gridPaint
      );
    }

    // Horizontal Scrolling Lines
    for (int i = 0; i < 8; i++) {
      // Calculate depth based on time 't' to create forward motion
      double progress = (i + t) / 8;
      double yPos = horizonY + (size.height - horizonY) * (progress * progress); // curve for perspective
      
      canvas.drawLine(
        Offset(0, yPos), 
        Offset(size.width, yPos), 
        Paint()
          ..color = const Color(0xFFFF003C).withOpacity(0.2 * progress)
          ..strokeWidth = 1.0 + (2.0 * progress)
      );
    }
  }

  @override
  bool shouldRepaint(_RetroWavePainter old) => old.t != t;
}