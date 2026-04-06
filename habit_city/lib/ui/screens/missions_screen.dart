import 'package:flutter/material.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  //  Palette (matches dashboard) 
  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFE040FB);
  static const _white      = Color(0xFFF0E6FF);

  //  Sample missions (replace with real data later) 
  static final List<_MissionData> _missions = [
    _MissionData(
      title: "Morning Hydration",
      desc: "Drink 500ml of water within 30 min of waking up",
      icon: Icons.water_drop_rounded,
      xp: 10, difficulty: 1,
      tag: "HEALTH", tagColor: _liteBlue,
      streak: 5,
    ),
    _MissionData(
      title: "Focus Block",
      desc: "Complete a 25-min Pomodoro session without distractions",
      icon: Icons.timer_rounded,
      xp: 20, difficulty: 2,
      tag: "MIND", tagColor: _pink,
      streak: 3,
    ),
    _MissionData(
      title: "Move Your Body",
      desc: "Do 20 push-ups, squats, or a 10-min walk",
      icon: Icons.fitness_center_rounded,
      xp: 30, difficulty: 3,
      tag: "BODY", tagColor: Colors.orangeAccent,
      streak: 0,
    ),
    _MissionData(
      title: "Read 10 Pages",
      desc: "Open a book and read at least 10 pages — no skimming",
      icon: Icons.menu_book_rounded,
      xp: 15, difficulty: 1,
      tag: "GROWTH", tagColor: _liteBlue,
      streak: 12,
    ),
    _MissionData(
      title: "Code Daily",
      desc: "Write or review at least 30 lines of meaningful code",
      icon: Icons.code_rounded,
      xp: 25, difficulty: 2,
      tag: "SKILL", tagColor: _purple,
      streak: 8,
    ),
    _MissionData(
      title: "No Doom Scroll",
      desc: "Avoid social media for the first hour after waking",
      icon: Icons.phone_locked_rounded,
      xp: 20, difficulty: 2,
      tag: "MIND", tagColor: _pink,
      streak: 1,
    ),
    _MissionData(
      title: "Sleep by Midnight",
      desc: "Lights out before 12:00 AM — no exceptions",
      icon: Icons.bedtime_rounded,
      xp: 15, difficulty: 1,
      tag: "HEALTH", tagColor: _liteBlue,
      streak: 2,
    ),
    _MissionData(
      title: "Gratitude Log",
      desc: "Write 3 things you're grateful for today",
      icon: Icons.edit_note_rounded,
      xp: 10, difficulty: 1,
      tag: "GROWTH", tagColor: Colors.greenAccent,
      streak: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,

      //  AppBar 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_black, _deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border(bottom: BorderSide(color: _purple, width: 2)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _purple,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _purple.withOpacity(0.7), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "MISSIONS",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // Mission count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _red.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      "${_missions.length} ACTIVE",
                      style: const TextStyle(
                        color: _red,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          //  Animated background 
          Positioned.fill(child: CustomPaint(painter: _MissionsBgPainter())),

          Column(
            children: [

              //  Hero banner 
              _MissionsHeroBanner(),

              //  Filter chips 
              _FilterChipRow(),

              const SizedBox(height: 8),

              //  Mission cards list 
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: _missions.length,
                  itemBuilder: (context, index) {
                    return _MissionCard(
                      data: _missions[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),

          //  "Swipe coming soon" floating hint 
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _deepPurple.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: _purple.withOpacity(0.4), width: 1),
                  boxShadow: [
                    BoxShadow(color: _purple.withOpacity(0.3), blurRadius: 20),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe_rounded, color: _liteBlue.withOpacity(0.8), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "",
                      style: TextStyle(
                        color: _white.withOpacity(0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Hero Banner 
class _MissionsHeroBanner extends StatelessWidget {
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 110,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E0040), Color(0xFF0D001A)],
        ),
        border: Border.all(color: _purple.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Stack(
        children: [
          // Speed lines
          Positioned.fill(child: CustomPaint(painter: _SpeedLinesPainter())),

          // Blue right aura
          Positioned(
            right: -10, top: -10, bottom: -10,
            width: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerRight,
                  colors: [_liteBlue.withOpacity(0.12), Colors.transparent],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Left: quote block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 3, height: 32,
                            decoration: BoxDecoration(
                              color: _red,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [BoxShadow(color: _red.withOpacity(0.6), blurRadius: 8)],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Every mission\ncompleted is XP earned.",
                              style: TextStyle(
                                color: _white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Build the streak. Break the limit.",
                        style: TextStyle(
                          color: _liteBlue.withOpacity(0.8),
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: today's progress ring
                _TodayRing(completed: 3, total: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  Today's progress ring 
class _TodayRing extends StatelessWidget {
  final int completed;
  final int total;
  const _TodayRing({required this.completed, required this.total});

  static const _liteBlue = Color(0xFF6EC6F5);
  static const _purple   = Color(0xFF7B2FBE);
  static const _white    = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(80, 80),
            painter: _RingPainter(
              progress: completed / total,
              trackColor: _purple.withOpacity(0.2),
              fillColor: _liteBlue,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$completed",
                style: const TextStyle(
                  color: _liteBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              Text(
                "/ $total",
                style: TextStyle(
                  color: _white.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2 - 6;
    const stroke = 6.0;
    const start  = -1.5708; // -π/2

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      0, 6.28318, false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    // Fill
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start, progress * 6.28318, false,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

//  Filter chip row 
class _FilterChipRow extends StatefulWidget {
  @override
  State<_FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<_FilterChipRow> {
  static const _purple   = Color(0xFF7B2FBE);
  static const _liteBlue = Color(0xFF6EC6F5);
  static const _white    = Color(0xFFF0E6FF);

  int _selected = 0;
  final _tags = ["ALL", "HEALTH", "MIND", "BODY", "SKILL", "GROWTH"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final active = _selected == i;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? _purple : _purple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: active ? _purple : _purple.withOpacity(0.25),
                    width: 1.2,
                  ),
                  boxShadow: active
                      ? [BoxShadow(color: _purple.withOpacity(0.45), blurRadius: 12)]
                      : null,
                ),
                child: Text(
                  _tags[i],
                  style: TextStyle(
                    color: active ? Colors.white : _white.withOpacity(0.45),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//  Mission Card 
class _MissionCard extends StatelessWidget {
  final _MissionData data;
  final int index;

  const _MissionCard({required this.data, required this.index});

  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _deepPurple.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        border: Border.all(color: _purple.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.1), blurRadius: 14),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // placeholder — wire to real logic later
            splashColor: _purple.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  //  Icon container 
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: data.tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: data.tagColor.withOpacity(0.4), width: 1.2),
                      boxShadow: [
                        BoxShadow(color: data.tagColor.withOpacity(0.15), blurRadius: 12),
                      ],
                    ),
                    child: Icon(data.icon, color: data.tagColor, size: 24),
                  ),

                  const SizedBox(width: 14),

                  //  Text block 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + tag row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.title,
                                style: const TextStyle(
                                  color: _white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Tag pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: data.tagColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: data.tagColor.withOpacity(0.4), width: 1),
                              ),
                              child: Text(
                                data.tag,
                                style: TextStyle(
                                  color: data.tagColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Description
                        Text(
                          data.desc,
                          style: TextStyle(
                            color: _white.withOpacity(0.45),
                            fontSize: 11,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Bottom row: difficulty dots + XP + streak
                        Row(
                          children: [
                            // Difficulty dots
                            ..._diffDots(data.difficulty),
                            const SizedBox(width: 10),
                            // XP chip
                            _XpChip(xp: data.xp),
                            const Spacer(),
                            // Streak
                            if (data.streak > 0)
                              _StreakBadge(streak: data.streak),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _diffDots(int level) {
    return List.generate(3, (i) {
      final filled = i < level;
      return Container(
        width: 7, height: 7,
        margin: const EdgeInsets.only(right: 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? _red : _red.withOpacity(0.15),
          boxShadow: filled
              ? [BoxShadow(color: _red.withOpacity(0.5), blurRadius: 6)]
              : null,
        ),
      );
    });
  }
}

// XP chip 
class _XpChip extends StatelessWidget {
  final int xp;
  const _XpChip({required this.xp});

  static const _liteBlue = Color(0xFF6EC6F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _liteBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _liteBlue.withOpacity(0.35), width: 1),
      ),
      child: Text(
        "+$xp XP",
        style: const TextStyle(
          color: _liteBlue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Streak badge 
class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("🔥", style: TextStyle(fontSize: 12)),
        const SizedBox(width: 3),
        Text(
          "${streak}d",
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

//  Mission data model
class _MissionData {
  final String title;
  final String desc;
  final IconData icon;
  final int xp;
  final int difficulty; // 1–3
  final String tag;
  final Color tagColor;
  final int streak;

  const _MissionData({
    required this.title,
    required this.desc,
    required this.icon,
    required this.xp,
    required this.difficulty,
    required this.tag,
    required this.tagColor,
    required this.streak,
  });
}

// Background painter 
class _MissionsBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0008),
    );

    // Speed lines from top-right
    final linePaint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final cx = size.width * 0.85;
    final cy = -size.height * 0.05;
    for (int i = 0; i < 22; i++) {
      final angle = (i / 22) * 3.14159 * 1.2 + 0.4;
      final ex = cx + size.height * 1.8 * _cos(angle);
      final ey = cy + size.height * 1.8 * _sin(angle);
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), linePaint);
    }

    // Bottom purple glow
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 1.1),
      size.width * 0.6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF7B2FBE).withOpacity(0.12),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 1.1),
          radius: size.width * 0.6,
        )),
    );
  }

  double _cos(double a) =>
      (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_) => false;
}

// Speed lines painter (for hero banner)
class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const cx = 0.0;
    final cy = size.height * 0.5;
    for (int i = 0; i < 16; i++) {
      final angle = (i / 16) * 3.14159 - 1.5708;
      final ex = cx + size.width * 2 * _cos(angle);
      final ey = cy + size.width * 2 * _sin(angle);
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), paint);
    }
  }

  double _cos(double a) =>
      (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_) => false;
}