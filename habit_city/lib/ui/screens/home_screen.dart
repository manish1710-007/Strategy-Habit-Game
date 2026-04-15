import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  //  Palette (Matching other screens)
  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFFF77E9); // Original pink
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Stack(
          children: [
            //  Background design 
            Positioned.fill(
              child: CustomPaint(painter: _HomeBgPainter()),
            ),

            //  Content 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  //  Header 
                  const Text(
                    "HABIT CITY",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: _white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Build your life like a strategy game.",
                    style: TextStyle(
                      color: _liteBlue.withOpacity(0.7),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 30),

                  //  Quote Box (Daily Insight) 
                  _QuoteBox(),

                  //  Spacer to push visual and buttons 
                  const Spacer(),

                  //  Center Visual (City Placeholder) 
                  Center(
                    child: _CityVisual(),
                  ),

                  const Spacer(),

                  //  Quick Actions (Glowing Buttons) 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _GlowButton(
                          icon: Icons.dashboard_rounded,
                          label: "DASH",
                          color: _red,
                          onTap: () => onNavigate(1),
                        ),
                        _GlowButton(
                          icon: Icons.flag_rounded,
                          label: "MISSIONS",
                          color: _purple,
                          onTap: () => onNavigate(2),
                        ),
                        _GlowButton(
                          icon: Icons.location_city_rounded,
                          label: "CITY",
                          color: _liteBlue,
                          onTap: () => onNavigate(3),
                        ),
                        _GlowButton(
                          icon: Icons.person_rounded,
                          label: "PROFILE",
                          color: _pink,
                          onTap: () => onNavigate(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Quote Box Widget 
class _QuoteBox extends StatelessWidget {
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _white      = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _deepPurple.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _purple.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _liteBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DAILY INSIGHT",
                  style: TextStyle(
                    color: _liteBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "You're 1 habit away from leveling up 🚀",
                  style: TextStyle(
                    color: _white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  City Visual Widget (Placeholder for the game map) 
class _CityVisual extends StatelessWidget {
  static const _purple = Color(0xFF7B2FBE);
  static const _pink   = Color(0xFFFF77E9);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Glowing orb behind
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _purple.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Placeholder Buildings
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBuilding(60, 80, _pink),
              _buildBuilding(50, 100, _purple),
              _buildBuilding(70, 90, _pink.withOpacity(0.7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double width, double height, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: color.withOpacity(0.6), width: 1),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 12),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            height: 8,
            color: color.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

//  Glowing Action Button 
class _GlowButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GlowButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0008),
              shape: BoxShape.circle,
              // The glowing border effect
              border: Border.all(color: color.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6), // Glow color
                  blurRadius: 12,
                  spreadRadius: 2, // Spread creates the glowing edge
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.9),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

//  Background Painter 
class _HomeBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base black
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = HomeScreen._black,
    );

    // Subtle radial gradient top center
    canvas.drawCircle(
      Offset(size.width * 0.5, -size.height * 0.1),
      size.width * 0.8,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF2D0057).withOpacity(0.3),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.5, -size.height * 0.1),
          radius: size.width * 0.8,
        )),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}