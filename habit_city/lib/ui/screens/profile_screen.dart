import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_state.dart';

class ProfileScreen extends StatelessWidget {
  // 1. Add the onNavigate callback
  final Function(int) onNavigate;

  const ProfileScreen({
    super.key,
    required this.onNavigate, // Make it required
  });

  //  Palette (consistent with other screens)
  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFE040FB);
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    // 2. Fetch real data from GameEngine
    final GameEngine = context.watch<GameEngine>();
    final xp = GameEngine.xp;
    final level = (xp ~/ 100) + 1;

    return Scaffold(
      backgroundColor: _black,

      //  Custom AppBar 
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
                  // 3. Updated Home Button
                  GestureDetector(
                    onTap: () => onNavigate(0), // Navigates to Home
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _red.withOpacity(0.7), blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "PROFILE",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // Settings Icon
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _purple.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: _purple.withOpacity(0.5), width: 1),
                    ),
                    child: const Icon(Icons.settings_rounded, color: _purple, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Background painter
          Positioned.fill(
            child: CustomPaint(painter: _ProfileBgPainter()),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                //  Avatar Section 
                _ProfileHeader(level: level),

                const SizedBox(height: 30),

                //  Stats Cards 
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.star_rounded,
                        label: "TOTAL XP",
                        value: "$xp",
                        color: _liteBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        label: "STREAK",
                        value: "7d", // Placeholder logic
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //  Level Progress 
                _LevelProgressCard(xp: xp, level: level),

                const SizedBox(height: 30),

                //  Action Buttons 
                _ActionTile(
                  icon: Icons.emoji_events_rounded,
                  title: "Achievements",
                  color: _pink,
                ),
                const SizedBox(height: 10),
                _ActionTile(
                  icon: Icons.history_rounded,
                  title: "History",
                  color: _purple,
                ),
                const SizedBox(height: 10),
                _ActionTile(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  color: _red,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  Profile Header (Avatar + Name)
class _ProfileHeader extends StatelessWidget {
  final int level;
  const _ProfileHeader({required this.level});

  static const _purple = Color(0xFF7B2FBE);
  static const _pink   = Color(0xFFE040FB);
  static const _white  = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with glowing border
        Container(
          padding: const EdgeInsets.all(4), // space for border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [_purple, _pink]),
            boxShadow: [
              BoxShadow(color: _purple.withOpacity(0.5), blurRadius: 20),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF1A003A),
            child: Text(
              "LV$level",
              style: const TextStyle(
                color: _white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "PLAYER ONE",
          style: TextStyle(
            color: _white,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Habit Hunter",
          style: TextStyle(
            color: _pink.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

//  Stat Card 
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  static const _white = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: _white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _white.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

//  Level Progress Card 
class _LevelProgressCard extends StatelessWidget {
  final int xp;
  final int level;
  const _LevelProgressCard({required this.xp, required this.level});

  static const _purple   = Color(0xFF7B2FBE);
  static const _liteBlue = Color(0xFF6EC6F5);
  static const _white    = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    final current = xp % 100;
    final progress = current / 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _purple.withOpacity(0.1),
        border: Border.all(color: _purple.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "NEXT LEVEL",
                style: TextStyle(
                  color: _white.withOpacity(0.6),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "$current / 100 XP",
                style: TextStyle(
                  color: _liteBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: _purple.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(_liteBlue),
            ),
          ),
        ],
      ),
    );
  }
}

//  Action Tile 
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
  });

  static const _white = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: const TextStyle(
            color: _white,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: _white.withOpacity(0.3)),
        onTap: () {},
      ),
    );
  }
}

//  Background Painter 
class _ProfileBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0008),
    );

    // Radial glow top center
    canvas.drawCircle(
      Offset(size.width * 0.5, -size.height * 0.1),
      size.width * 0.8,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF2D0057).withOpacity(0.4),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.5, -size.height * 0.1),
          radius: size.width * 0.8,
        )),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}