import 'package:flutter/material.dart';
import '../../models/habit.dart';
import '../../services/storage_service.dart';
import '../widgets/habit_card.dart';
import 'package:uuid/uuid.dart';
import '../widgets/particle_burst.dart';
import '../widgets/waifu_character.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final box = StorageService.getHabitBox();
  bool showParticle = false;
  Offset particlePosition = Offset.zero;

  WaifuMood mood = WaifuMood.idle;
  List<Habit> habits = [];
  int energy = 100;
  int xp = 0;

  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  // Palette
  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _white      = Color(0xFFF0E6FF);

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

  void completeHabit(Habit habit, Offset position) async {
    if (habit.completed) return;
    final gainedXP = habit.difficulty * 10;
    setState(() {
      habit.completed = true;
      xp += gainedXP;
      energy += habit.difficulty * 5;
      mood = WaifuMood.happy;
      showParticle = true;
      particlePosition = position;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => showParticle = false);
        setState(() => mood = WaifuMood.idle);
      }
    });
    box.put(habit.id, habit.toMap());
    final oldLevel = (xp - gainedXP) ~/ 100 + 1;
    final newLevel = xp ~/ 100 + 1;
    if (newLevel > oldLevel) {
      setState(() => mood = WaifuMood.excited);
      _showLevelUpDialog(newLevel);
    }
  }

  void _showLevelUpDialog(int level) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: _black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _purple, width: 2.5),
              boxShadow: [
                BoxShadow(color: _purple.withOpacity(0.6), blurRadius: 24, spreadRadius: 2),
                BoxShadow(color: _red.withOpacity(0.4), blurRadius: 40, spreadRadius: -4),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Comic-style "LEVEL UP!" banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _red,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(color: _red.withOpacity(0.7), blurRadius: 12)],
                  ),
                  child: const Text(
                    "LEVEL UP!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "You reached Level $level",
                  style: const TextStyle(color: _white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_purple, _liteBlue],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: _liteBlue.withOpacity(0.4), blurRadius: 14),
                      ],
                    ),
                    child: const Text(
                      "NICE! ⚡",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      // AppBar 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_black, _deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border(
              bottom: BorderSide(color: _purple, width: 2),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Comic-style logo mark
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _red,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _red.withOpacity(0.7), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "MISSION BOARD",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // Halftone dot accent
                  _HalftoneAccent(),
                ],
              ),
            ),
          ),
        ),
      ),

      // FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [_red, _purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: _purple.withOpacity(0.7), blurRadius: 16, spreadRadius: 1),
            BoxShadow(color: _red.withOpacity(0.4), blurRadius: 30, spreadRadius: -4),
          ],
        ),
        child: FloatingActionButton(
          onPressed: addHabit,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),

      // Body
      body: Stack(
        children: [
          // Animated comic-book background
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (context, _) => _ComicBackground(t: _bgAnim.value),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Cinematic Header
                _DashboardHeader(
                  energy: energy,
                  xp: xp,
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
                              Icon(Icons.bolt_outlined, color: _purple.withOpacity(0.4), size: 56),
                              const SizedBox(height: 12),
                              const Text(
                                "NO MISSIONS YET",
                                style: TextStyle(
                                  color: _purple,
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: habit.completed
                                        ? _purple.withOpacity(0.3)
                                        : _purple.withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                  boxShadow: habit.completed
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: _purple.withOpacity(0.15),
                                            blurRadius: 12,
                                          ),
                                        ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: HabitCard(
                                    habit: habit,
                                    onTapWithPosition: (pos) =>
                                        completeHabit(habit, pos),
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

  Widget _resourceChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.8), width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _xpBar(int totalXP) {
    final level = totalXP ~/ 100 + 1;
    final currentXP = totalXP % 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _red,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: _red.withOpacity(0.5), blurRadius: 8)],
              ),
              child: Text(
                "LV.$level",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: _purple.withOpacity(0.3), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: currentXP / 100,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation(_liteBlue),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$currentXP / 100 XP",
          style: TextStyle(color: _white.withOpacity(0.5), fontSize: 11),
        ),
      ],
    );
  }
}

// Comic halftone accent widget
class _HalftoneAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(painter: _HalftonePainter()),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF7B2FBE);
    final paint = Paint()..color = color.withOpacity(0.6);
    const dotR = 2.5;
    const gap = 7.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), dotR, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// Animated comic background
class _ComicBackground extends StatelessWidget {
  final double t;
  const _ComicBackground({required this.t});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _ComicBgPainter(t: t)),
    );
  }
}

class _ComicBgPainter extends CustomPainter {
  final double t;
  const _ComicBgPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0A0008),
          Color.lerp(const Color(0xFF1A003A), const Color(0xFF0D0020), t)!,
          const Color(0xFF0A0008),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Speed lines radiating from top-center (comic book effect)
    final linePaint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.07)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.5, -size.height * 0.1);
    for (int i = 0; i < 28; i++) {
      final angle = (i / 28) * 3.14159 * 2;
      final end = Offset(
        center.dx + size.height * 1.8 * _cos(angle),
        center.dy + size.height * 1.8 * _sin(angle),
      );
      canvas.drawLine(center, end, linePaint);
    }

    // Subtle halftone dot grid in corners
    final dotPaint = Paint()
      ..color = const Color(0xFFCC1C3A).withOpacity(0.06);
    for (double x = 0; x < size.width * 0.3; x += 14) {
      for (double y = size.height * 0.7; y < size.height; y += 14) {
        final r = 3.0 * (0.5 + 0.5 * t);
        canvas.drawCircle(Offset(x, y), r, dotPaint);
      }
    }

    // Top-right blue glow blob
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6EC6F5).withOpacity(0.12 + 0.05 * t),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
            center: Offset(size.width * 0.9, size.height * 0.1),
            radius: size.width * 0.4),
      );
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.1), size.width * 0.4, glowPaint);

    // Bottom-left purple glow blob
    final glowPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF7B2FBE).withOpacity(0.15 + 0.06 * t),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
            center: Offset(size.width * 0.1, size.height * 0.9),
            radius: size.width * 0.5),
      );
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.9), size.width * 0.5, glowPaint2);
  }

  double _cos(double a) => (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_ComicBgPainter old) => old.t != t;
}

// Dashboard Header Widget
class _DashboardHeader extends StatelessWidget {
  final int energy;
  final int xp;
  final WaifuMood mood;

  const _DashboardHeader({
    required this.energy,
    required this.xp,
    required this.mood,
  });

  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFE040FB);
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    final level   = xp ~/ 100 + 1;
    final current = xp % 100;

    return Container(
      height: 160,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A003A), Color(0xFF0D0020)],
        ),
        border: Border.all(color: _purple.withOpacity(0.45), width: 1.5),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.25), blurRadius: 28, spreadRadius: -2),
          BoxShadow(color: _red.withOpacity(0.1),    blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [

          // Background: speed lines
          Positioned.fill(child: CustomPaint(painter: _HeaderBgPainter())),

          // Background: right-side blue aura
          Positioned(
            right: -20, top: -20, bottom: -20,
            width: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerRight,
                  colors: [
                    _liteBlue.withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Background: red bottom-left bleed 
          Positioned(
            left: -30, bottom: -30,
            width: 140, height: 140,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  _red.withOpacity(0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Halftone dots — top right corner
          Positioned(
            top: 0, right: 0,
            width: 90, height: 90,
            child: CustomPaint(painter: _HalftonePainterColored(
              color: _purple.withOpacity(0.18),
            )),
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
                      // Waifu — overflows upward for drama
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: WaifuCharacter(mood: mood),
                      ),
                      // Energy chip pinned bottom-left
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: _EnergyChip(energy: energy),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                //  DIVIDER
                Container(
                  width: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _purple.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // RIGHT: Level + XP 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Level row
                      Row(
                        children: [
                          // Level badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_red, Color(0xFF9B1A30)],
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: _red.withOpacity(0.5),
                                    blurRadius: 10),
                              ],
                            ),
                            child: Text(
                              "LV.$level",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Rank label
                          Text(
                            _rankLabel(level),
                            style: TextStyle(
                              color: _pink.withOpacity(0.85),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // XP label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "EXPERIENCE",
                            style: TextStyle(
                              color: _white.withOpacity(0.4),
                              fontSize: 9,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "$current / 100 XP",
                            style: TextStyle(
                              color: _liteBlue.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // XP bar — segmented comic style
                      _SegmentedXPBar(value: current / 100),

                      const SizedBox(height: 14),

                      // Stat pills row
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
                            color: _liteBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Comic "WOW" splash — top left accent
          Positioned(
            top: 8, left: 108,
            child: _ComicSplash(),
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
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.yellowAccent.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.yellowAccent.withOpacity(0.15), blurRadius: 10),
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
              color: Colors.yellowAccent,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Segmented XP bar (comic panel style)
class _SegmentedXPBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  const _SegmentedXPBar({required this.value});

  static const _liteBlue = Color(0xFF6EC6F5);
  static const _purple   = Color(0xFF7B2FBE);

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
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: active
                  ? Color.lerp(_purple, _liteBlue, i / segments)
                  : Colors.white.withOpacity(0.07),
              boxShadow: active
                  ? [BoxShadow(
                      color: _liteBlue.withOpacity(0.4),
                      blurRadius: 6,
                    )]
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

// Comic splash accent
class _ComicSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 24),
      painter: _ComicSplashPainter(),
    );
  }
}

class _ComicSplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw a jagged starburst blob
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    const points = 8;
    const outer = 11.0;
    const inner = 6.0;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159) / points - 1.5708;
      final r = i.isEven ? outer : inner;
      final x = cx + r * _cos(angle);
      final y = cy + r * _sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFCC1C3A)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  double _cos(double a) => (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_) => false;
}

// Header background painter
class _HeaderBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final cx = size.width * 0.15;
    final cy = size.height * 1.1;

    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 3.14159;
      final ex = cx + size.width * 1.4 * _cos(angle);
      final ey = cy + size.width * 1.4 * _sin(angle);
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), paint);
    }
  }

  double _cos(double a) => (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_) => false;
}

// Halftone painter (reusable)
class _HalftonePainterColored extends CustomPainter {
  final Color color;
  const _HalftonePainterColored({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const gap = 9.0;
    const r   = 2.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}