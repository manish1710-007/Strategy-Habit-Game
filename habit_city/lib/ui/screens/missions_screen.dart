import 'package:flutter/material.dart';
import 'package:habit_city/core/game_engine.dart';

class MissionsScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const MissionsScreen({
    super.key, 
    required this.onNavigate,
  });

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionAction extends StatelessWidget {
  final _MissionData data;
  final GameEngine gameEngine;

  const _MissionAction({required this.data, required this.gameEngine});

  void _completeMission(BuildContext context) {
    // Award XP based on difficulty
    gameEngine.completeActivity(data.title, data.difficulty);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("+${data.difficulty * 10} XP * Streak: ${gameEngine.streakDays}d"),
        backgroundColor: const Color(0XFF00F0FF),
        duration: const Duration(seconds: 1),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // This helper widget is not shown directly; keep a small placeholder.
    return const SizedBox.shrink();
  }
}


class _MissionsScreenState extends State<MissionsScreen> {
  // 🎨 Retro Futuristic Palette (Synced with Dashboard)
  static const _black    = Color(0xFF050508); 
  static const _void     = Color(0xFF0A0D14); 
  static const _neonBlue = Color(0xFF00F0FF); 
  static const _neonRed  = Color(0xFFFF003C); 
  static const _white    = Color(0xFFE0E5FF); 

  // State for filtering
  String _selectedFilter = "ALL";

  // Initial Sample Missions (XP and Streak set to 0)
  final List<_MissionData> _missions = [
    _MissionData(
      title: "Morning Hydration",
      desc: "Drink 500ml of water within 30 min of waking up",
      icon: Icons.water_drop_rounded,
      xp: 0, difficulty: 1,
      tag: "HEALTH", tagColor: _neonBlue,
      streak: 0,
    ),
    _MissionData(
      title: "Focus Block",
      desc: "Complete a 25-min Pomodoro session without distractions",
      icon: Icons.timer_rounded,
      xp: 0, difficulty: 2,
      tag: "MIND", tagColor: const Color(0xFFFF00FF), // Neon Magenta
      streak: 0,
    ),
    _MissionData(
      title: "Move Your Body",
      desc: "Do 20 push-ups, squats, or a 10-min walk",
      icon: Icons.fitness_center_rounded,
      xp: 0, difficulty: 3,
      tag: "BODY", tagColor: Colors.orangeAccent,
      streak: 0,
    ),
    _MissionData(
      title: "Read 10 Pages",
      desc: "Open a book and read at least 10 pages — no skimming",
      icon: Icons.menu_book_rounded,
      xp: 0, difficulty: 1,
      tag: "GROWTH", tagColor: _neonBlue,
      streak: 0,
    ),
    _MissionData(
      title: "Code Daily",
      desc: "Write or review at least 30 lines of meaningful code",
      icon: Icons.code_rounded,
      xp: 0, difficulty: 2,
      tag: "SKILL", tagColor: _neonRed,
      streak: 0,
    ),
    _MissionData(
      title: "No Doom Scroll",
      desc: "Avoid social media for the first hour after waking",
      icon: Icons.phone_locked_rounded,
      xp: 0, difficulty: 2,
      tag: "MIND", tagColor: const Color(0xFFFF00FF),
      streak: 0,
    ),
    _MissionData(
      title: "Sleep by Midnight",
      desc: "Lights out before 12:00 AM — no exceptions",
      icon: Icons.bedtime_rounded,
      xp: 0, difficulty: 1,
      tag: "HEALTH", tagColor: _neonBlue,
      streak: 0,
    ),
    _MissionData(
      title: "Gratitude Log",
      desc: "Write 3 things you're grateful for today",
      icon: Icons.edit_note_rounded,
      xp: 0, difficulty: 1,
      tag: "GROWTH", tagColor: Colors.greenAccent,
      streak: 0,
    ),
  ];

  List<_MissionData> get filteredMissions {
    if (_selectedFilter == "ALL") return _missions;
    return _missions.where((m) => m.tag == _selectedFilter).toList();
  }

  void _addNewMission(String title, String tag) {
    setState(() {
      _missions.insert(0, _MissionData(
        title: title,
        desc: "Custom User Protocol Inserted",
        icon: Icons.api_rounded, // Generic tech icon for custom ones
        xp: 0, difficulty: 1,
        tag: tag, tagColor: _neonBlue,
        streak: 0,
      ));
    });
  }

  void _showAddMissionDialog() {
    final TextEditingController titleController = TextEditingController();
    String selectedDialogTag = "GROWTH"; // default
    final List<String> dialogTags = ["HEALTH", "MIND", "BODY", "SKILL", "GROWTH"];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // StatefulBuilder allows dropdown/chips to update inside dialog
        builder: (context, setDialogState) {
          return Dialog(
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
                    "COMPILE NEW MISSION",
                    style: TextStyle(
                      color: _neonBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
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
                      hintText: "Enter mission parameters...",
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
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ASSIGN SECTOR",
                    style: TextStyle(color: _neonRed, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dialogTags.map((tag) {
                      final isSelected = selectedDialogTag == tag;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedDialogTag = tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? _neonRed.withOpacity(0.2) : Colors.transparent,
                            border: Border.all(color: isSelected ? _neonRed : _neonBlue.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag, 
                            style: TextStyle(
                              color: isSelected ? _neonRed : _white.withOpacity(0.5),
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            )
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("ABORT", style: TextStyle(color: _neonRed, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          if (titleController.text.trim().isNotEmpty) {
                            _addNewMission(titleController.text.trim(), selectedDialogTag);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [_neonBlue, Color(0xFF0088AA)]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "COMPILE",
                            style: TextStyle(color: _black, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayMissions = filteredMissions;

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
                  // Updated Home Button
                  GestureDetector(
                    onTap: () => widget.onNavigate(0), 
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _black,
                        border: Border.all(color: _neonRed, width: 1.5),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _neonRed.withOpacity(0.5), blurRadius: 10)],
                      ),
                      child: const Icon(Icons.home_rounded, color: _neonRed, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "DATABASE",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // Dynamic Mission count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _neonRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _neonRed.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      "${displayMissions.length} ACTIVE",
                      style: const TextStyle(
                        color: _neonRed,
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

      // NEW FAB for Missions
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [_neonBlue, Color(0xFF0088AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.6), blurRadius: 16, spreadRadius: 1)],
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
          // Cyber Grid Background
          Positioned.fill(child: CustomPaint(painter: _CyberGridPainter())),

          Column(
            children: [
              // Hero banner 
              _MissionsHeroBanner(totalMissions: displayMissions.length),

              // Filter chips (Pass state and callback)
              _FilterChipRow(
                selectedFilter: _selectedFilter,
                onFilterChanged: (tag) => setState(() => _selectedFilter = tag),
              ),

              const SizedBox(height: 8),

              // Mission cards list 
              Expanded(
                child: displayMissions.isEmpty 
                  ? Center(
                      child: Text(
                        "NO PROTOCOLS FOUND IN [$_selectedFilter]",
                        style: TextStyle(color: _neonBlue.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 2),
                      )
                    )
                  : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: displayMissions.length,
                  itemBuilder: (context, index) {
                    return _MissionCard(
                      data: displayMissions[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),

          // "Swipe coming soon" floating hint 
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _void.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: _neonBlue.withOpacity(0.4), width: 1),
                  boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.2), blurRadius: 20)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe_rounded, color: _neonBlue.withOpacity(0.8), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "SWIPE ACTIONS OFFLINE",
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

// Hero Banner 
class _MissionsHeroBanner extends StatelessWidget {
  final int totalMissions;

  const _MissionsHeroBanner({required this.totalMissions});

  static const _black    = Color(0xFF050508); 
  static const _neonBlue = Color(0xFF00F0FF); 
  static const _neonRed  = Color(0xFFFF003C); 
  static const _white    = Color(0xFFE0E5FF); 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 110,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0A0D14),
        border: Border.all(color: _neonBlue.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 20),
        ],
      ),
      child: Stack(
        children: [
          // Cyber lines background
          Positioned.fill(child: CustomPaint(painter: _SpeedLinesPainter())),

          // Blue right aura
          Positioned(
            right: -20, top: -20, bottom: -20,
            width: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerRight,
                  colors: [_neonBlue.withOpacity(0.2), Colors.transparent],
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
                              color: _neonRed,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [BoxShadow(color: _neonRed.withOpacity(0.6), blurRadius: 8)],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Compile daily objectives.\nExecute without failure.",
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
                        "SYSTEM OPTIMIZATION IN PROGRESS...",
                        style: TextStyle(
                          color: _neonBlue.withOpacity(0.8),
                          fontSize: 9,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Dynamic ring (Using 0 completed for now since XP is 0)
                _TodayRing(completed: 0, total: totalMissions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Today's progress ring 
class _TodayRing extends StatelessWidget {
  final int completed;
  final int total;
  const _TodayRing({required this.completed, required this.total});

  static const _neonBlue = Color(0xFF00F0FF); 
  static const _void     = Color(0xFF0A0D14); 
  static const _white    = Color(0xFFE0E5FF); 

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
              progress: total == 0 ? 0 : completed / total,
              trackColor: _neonBlue.withOpacity(0.15),
              fillColor: _neonBlue,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$completed",
                style: const TextStyle(
                  color: _neonBlue,
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
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// Filter chip row (Now fully functional!)
class _FilterChipRow extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const _FilterChipRow({
    required this.selectedFilter, 
    required this.onFilterChanged
  });

  static const _neonBlue = Color(0xFF00F0FF); 
  static const _white    = Color(0xFFE0E5FF); 

  final _tags = const ["ALL", "HEALTH", "MIND", "BODY", "SKILL", "GROWTH"];

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
            final String tag = _tags[i];
            final active = selectedFilter == tag;

            return GestureDetector(
              onTap: () => onFilterChanged(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? _neonBlue.withOpacity(0.8) : _neonBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: active ? _neonBlue : _neonBlue.withOpacity(0.25),
                    width: 1.2,
                  ),
                  boxShadow: active
                      ? [BoxShadow(color: _neonBlue.withOpacity(0.45), blurRadius: 12)]
                      : null,
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: active ? Color(0xFF050508) : _white.withOpacity(0.45), // Black text when active
                    fontWeight: FontWeight.w900,
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

// Mission Card 
class _MissionCard extends StatelessWidget {
  final _MissionData data;
  final int index;

  const _MissionCard({required this.data, required this.index});

  static const _void     = Color(0xFF0A0D14); 
  static const _neonBlue = Color(0xFF00F0FF); 
  static const _neonRed  = Color(0xFFFF003C); 
  static const _white    = Color(0xFFE0E5FF); 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: _void,
        border: Border.all(color: _neonBlue.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.05), blurRadius: 14),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, 
            splashColor: _neonBlue.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container 
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

                  // Text block 
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: data.tagColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: data.tagColor.withOpacity(0.4), width: 1),
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
                            // Streak - Modified to always show, even if 0, per user rules
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
          color: filled ? _neonRed : _neonRed.withOpacity(0.15),
          boxShadow: filled
              ? [BoxShadow(color: _neonRed.withOpacity(0.5), blurRadius: 6)]
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

  static const _neonBlue = Color(0xFF00F0FF); 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _neonBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _neonBlue.withOpacity(0.35), width: 1),
      ),
      child: Text(
        "+$xp XP",
        style: const TextStyle(
          color: _neonBlue,
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
        Opacity(
          opacity: streak > 0 ? 1.0 : 0.3, // Dim the fire if streak is 0
          child: const Text("🔥", style: TextStyle(fontSize: 12))
        ),
        const SizedBox(width: 3),
        Text(
          "${streak}d",
          style: TextStyle(
            color: streak > 0 ? Colors.orangeAccent : Colors.grey, // Grey out text if 0
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// Mission data model
class _MissionData {
  final String title;
  final String desc;
  final IconData icon;
  final int xp;
  final int difficulty; 
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

// New Cyber Grid Background 
class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF050508),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.03)
      ..strokeWidth = 1.0;

    const gap = 30.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// Speed lines painter (for hero banner)
class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.06)
      ..strokeWidth = 1.5
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

  double _cos(double a) => (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
  double _sin(double a) {
    final b = a - 1.5708;
    return _cos(b < 0 ? b + 6.28318 : b);
  }

  @override
  bool shouldRepaint(_) => false;
}