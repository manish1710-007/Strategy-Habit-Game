import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  // 🎨 Enhanced Palette (Neon + Neo-Brutalism)
  static const _black = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple = Color(0xFF7B2FBE);
  static const _red = Color(0xFFCC1C3A);
  static const _liteBlue = Color(0xFF6EC6F5);
  static const _pink = Color(0xFFFF77E9);
  static const _white = Color(0xFFF0E6FF);
  static const _neonCyan = Color(0xFF00F0FF); // NEW: Cyberpunk accent
  static const _neonYellow = Color(0xFFFFD700); // NEW: Pop accent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Stack(
          children: [
            // 🌌 Chaotic Background Layer
            Positioned.fill(
              child: CustomPaint(painter: _NeoGrungeBgPainter()),
            ),

            // 🎭 Decorative "Stickers" (Randomly positioned comic elements)
            ...List.generate(5, (i) => _RandomSticker(i)),

            // 📦 Main Content Layer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 🏷️ Glitch Header
                  Transform.rotate(
                    angle: -0.02, // Slight crooked tilt
                    child: _GlitchText(
                      text: "HABIT CITY",
                      fontSize: 32,
                      color: _white,
                      glowColor: _neonCyan,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Transform.rotate(
                    angle: 0.015,
                    child: Text(
                      "Build your life like a strategy game ⚡",
                      style: TextStyle(
                        color: _liteBlue.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier', // Typewriter vibe
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 💬 Comic-Style Quote Box
                  _NeoQuoteBox(),

                  const Spacer(),

                  // 🗼 Character + City Visual (Blended Waifu Area)
                  Transform.rotate(
                    angle: 0.03,
                    child: _CharacterCityBlend(),
                  ),

                  const Spacer(),

                  // 🎮 Neo-Brutalist Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _BrutalistButton(
                          icon: Icons.dashboard_rounded,
                          label: "DASH",
                          color: _red,
                          onTap: () => onNavigate(1),
                        ),
                        _BrutalistButton(
                          icon: Icons.flag_rounded,
                          label: "MISSIONS",
                          color: _purple,
                          onTap: () => onNavigate(2),
                        ),
                        _BrutalistButton(
                          icon: Icons.location_city_rounded,
                          label: "CITY",
                          color: _liteBlue,
                          onTap: () => onNavigate(3),
                        ),
                        _BrutalistButton(
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

            // ✨ Scanline Overlay (Retro CRT effect)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: List.generate(
                        20,
                        (_) => _black.withOpacity(0.03),
                      ),
                      stops: List.generate(20, (i) => i / 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎭 Random Comic Sticker Widget (Chaotic Decoration)
class _RandomSticker extends StatelessWidget {
  final int index;
  const _RandomSticker(this.index);

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(index);
    final positions = [
      Offset(rng.nextDouble() * 80 + 10, rng.nextDouble() * 60 + 10),
    ][0];
    final rotations = [-0.1, 0.08, -0.05, 0.12, -0.07];
    final stickers = ['💥', '✨', '⚡', '🎯', '🔥'];

    return Positioned(
      left: positions.dx * MediaQuery.of(context).size.width / 100,
      top: positions.dy * MediaQuery.of(context).size.height / 100,
      child: Transform.rotate(
        angle: rotations[index % rotations.length],
          child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: HomeScreen._white,
            border: Border.all(color: HomeScreen._black, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: HomeScreen._black,
                offset: const Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            stickers[index % stickers.length],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// 💬 Neo-Brutalist Quote Box
class _NeoQuoteBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.015,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HomeScreen._deepPurple.withOpacity(0.8),
          border: Border.all(color: HomeScreen._black, width: 3), // Thick border!
          boxShadow: [
            BoxShadow(
              color: HomeScreen._black,
              offset: const Offset(5, 5), // Hard shadow
              blurRadius: 0,
            ),
            BoxShadow(
              color: HomeScreen._neonCyan.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Jagged accent bar
            ClipPath(
              clipper: _JaggedClipper(),
              child: Container(
                width: 6,
                height: 40,
                color: HomeScreen._neonYellow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "⚡ DAILY INSIGHT",
                    style: TextStyle(
                      color: HomeScreen._neonCyan,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "You're 1 habit away from leveling up 🚀",
                    style: TextStyle(
                      color: HomeScreen._white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Comic burst icon
            const Icon(Icons.flash_on, color: Colors.yellow, size: 24),
          ],
        ),
      ),
    );
  }
}

// 🗼 Character + City Blend (Waifu Integration Zone)
class _CharacterCityBlend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Halftone pattern overlay
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                HomeScreen._purple.withOpacity(0.15),
                BlendMode.overlay,
              ),
              child: Image.asset(
                'assets/halftone_pattern.png', // Add this asset!
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(),
              ),
            ),
          ),
          
          // Character silhouette placeholder (Replace with your waifu!)
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: _JaggedImageClipper(), // Jagged cutout effect
              child: Container(
                width: 160,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HomeScreen._pink.withOpacity(0.6),
                      HomeScreen._liteBlue.withOpacity(0.4),
                    ],
                  ),
                  border: Border.all(
                    color: HomeScreen._white.withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white70,
                    size: 60,
                  ),
                ),
              ),
            ),
          ),

          // Floating neon orb
          Positioned(
            top: 20,
            right: 40,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HomeScreen._neonCyan.withOpacity(0.3),
                border: Border.all(color: HomeScreen._neonCyan, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: HomeScreen._neonCyan,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎮 Neo-Brutalist Button (Thick borders, hard shadows, POP effect)
class _BrutalistButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BrutalistButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_BrutalistButton> createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<_BrutalistButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Transform.rotate(
        angle: _pressed ? 0.02 : -0.02, // Slight wobble on press
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(
            0,
            _pressed ? 4 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: HomeScreen._black, width: 3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: HomeScreen._black,
                offset: Offset(_pressed ? 0 : 5, _pressed ? 0 : 5),
                blurRadius: 0, // Hard shadow = brutalist!
              ),
              if (!_pressed)
                BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: -3,
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: HomeScreen._black, size: 22),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: HomeScreen._black,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    fontFamily: 'BebasNeue', // Add this font!
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🌌 Neo-Grunge Background Painter
class _NeoGrungeBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base black
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = HomeScreen._black,
    );

    // Grid lines (retro-futuristic)
    final gridPaint = Paint()
      ..color = HomeScreen._deepPurple.withOpacity(0.3)
      ..strokeWidth = 1;

    for (var i = 0.0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Radial neon glow
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.4,
      Paint()
        ..shader = RadialGradient(
          colors: [
            HomeScreen._neonCyan.withOpacity(0.15),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.8, size.height * 0.2),
            radius: size.width * 0.4,
          ),
        ),
    );

    // Noise texture overlay (subtle grain)
    final noisePaint = Paint()
      ..color = HomeScreen._white.withOpacity(0.03)
      ..blendMode = BlendMode.overlay;
    // Note: For real noise, use an image asset or shader
  }

  @override
  bool shouldRepaint(_) => false;
}

// ✂️ Jagged Clipper for "torn paper" effect
class _JaggedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    for (var i = 0; i < size.width; i += 8) {
      final jitter = (i % 16 == 0) ? 3 : -3;
      path.lineTo(i.toDouble(), jitter.toDouble());
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

// ✂️ Jagged Image Clipper for character cutouts
class _JaggedImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 20);
    // Create jagged left edge
    for (var i = 0; i < size.height - 20; i += 15) {
      final offset = (i ~/ 15) % 2 == 0 ? 8 : -8;
      path.lineTo(offset.toDouble(), 20 + i.toDouble());
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

// ⚡ Glitch Text Effect Widget
class _GlitchText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Color glowColor;

  const _GlitchText({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.glowColor,
  });

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glitchOffset = math.sin(_controller.value * 6.28 * 3) * 2;
        return Stack(
          children: [
            // Red channel offset
            Positioned(
              left: glitchOffset,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.withOpacity(0.7),
                  letterSpacing: 4,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            // Cyan channel offset
            Positioned(
              left: -glitchOffset,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  color: widget.glowColor.withOpacity(0.7),
                  letterSpacing: 4,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            // Main text
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w900,
                color: widget.color,
                letterSpacing: 4,
                fontFamily: 'BebasNeue',
                shadows: [
                  Shadow(
                    color: widget.glowColor.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}