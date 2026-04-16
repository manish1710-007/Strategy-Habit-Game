import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final String? gifAssetPath;
  
  const HomeScreen({
    super.key, 
    required this.onNavigate,
    this.gifAssetPath,

  });

   
  static const _voidBlack = Color(0xFF050011);
  static const _deepVoid = Color(0xFF0D0033);
  static const _electricPurple = Color(0xFFB829F7);
  static const _hotPink = Color(0xFFFF00A0);
  static const _cyanBlast = Color(0xFF00F0FF);
  static const _acidGreen = Color(0xFF39FF14);
  static const _laserRed = Color(0xFFFF0040);
  static const _solarYellow = Color(0xFFFFE600);
  static const _whiteOut = Color(0xFFFFFFFF);
  static const _ghostWhite = Color(0xFFE0E0FF);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen._voidBlack,
      body: Stack(
        children: [
          // 
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ComicBookBgPainter(
                    pulseValue: _pulseController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: _SpeedLinesPainter(),
            ),
          ),

          ...List.generate(6, (i) => _FloatingNeonOrb(index: i)),

          
          // Main Content                                       
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Comic Book Issue Badge
                  _ComicIssueBadge(),

                  const SizedBox(height: 12),

                  // Glitch Title with Neon Bloom
                  _NeonGlitchTitle(
                    text: "HABIT CITY",
                    fontSize: 42,
                  ),

                  // Subtitle with typewriter cursor
                  _TypewriterSubtitle(
                    text: "Build Your Life Like A Strategy Game ⚡",
                  ),

                  const SizedBox(height: 20),

                
                  //   COMIC BOOK QUOTE BOX - With Glow Border                     
    
                  _NeonQuoteBox(),

                  const Spacer(),

                  
                  //   HERO ZONE: GIF + Character Integration                      
                  
                  _HeroGifZone(
                    gifAssetPath: widget.gifAssetPath,
                    floatController: _floatController,
                  ),

                  const Spacer(),

                  
                  //   NEON ACTION BUTTONS - Comic Book Style                    
        
                  _NeonButtonRow(onNavigate: widget.onNavigate),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          
          // CRT Scanline & Chromatic Aberration Overlay        
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CRTPainter(
                      scanPosition: _scanController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          
          //  Vignette & Film Grain                              
          
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      HomeScreen._voidBlack.withOpacity(0.4),
                      HomeScreen._voidBlack.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//   COMIC BOOK BACKGROUND PAINTER                                
class _ComicBookBgPainter extends CustomPainter {
  final double pulseValue;

  _ComicBookBgPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        HomeScreen._deepVoid,
        HomeScreen._voidBlack,
        HomeScreen._deepVoid.withBlue(80),
      ],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = baseGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      ),
    );

    // Halftone dot pattern
    final dotPaint = Paint()
      ..color = HomeScreen._electricPurple.withOpacity(0.1 + pulseValue * 0.05)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        final radius = 2 + math.sin((x + y) * 0.02) * 1.5;
        canvas.drawCircle(Offset(x, y), radius.abs(), dotPaint);
      }
    }

    // Neon grid lines
    final gridPaint = Paint()
      ..color = HomeScreen._cyanBlast.withOpacity(0.08)
      ..strokeWidth = 1;

    for (var i = 0.0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Radial glow bursts
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          HomeScreen._hotPink.withOpacity(0.15 * pulseValue),
          HomeScreen._electricPurple.withOpacity(0.1 * pulseValue),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.2, size.height * 0.3),
          radius: size.width * 0.6,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.6,
      glowPaint,
    );

    // Second glow burst
    final glowPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          HomeScreen._cyanBlast.withOpacity(0.12 * (1 - pulseValue)),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.7),
          radius: size.width * 0.5,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      size.width * 0.5,
      glowPaint2,
    );
  }

  @override
  bool shouldRepaint(covariant _ComicBookBgPainter oldDelegate) => true;
}

//   SPEED LINES PAINTER - Action Burst Effect                    
class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.6);
    final linePaint = Paint()
      ..color = HomeScreen._whiteOut.withOpacity(0.03)
      ..strokeWidth = 1;

    // Radiating speed lines
    for (int i = 0; i < 24; i++) {
      final angle = (i / 24) * 2 * math.pi;
      final startRadius = size.width * 0.3;
      final endRadius = size.width * 0.9;

      final start = Offset(
        center.dx + math.cos(angle) * startRadius,
        center.dy + math.sin(angle) * startRadius,
      );
      final end = Offset(
        center.dx + math.cos(angle) * endRadius,
        center.dy + math.sin(angle) * endRadius,
      );

      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}


//   FLOATING NEON ORBS                                           
class _FloatingNeonOrb extends StatefulWidget {
  final int index;
  const _FloatingNeonOrb({required this.index});

  @override
  State<_FloatingNeonOrb> createState() => _FloatingNeonOrbState();
}

class _FloatingNeonOrbState extends State<_FloatingNeonOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000 + widget.index * 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(widget.index);
    final left = rng.nextDouble() * 0.8 + 0.1;
    final top = rng.nextDouble() * 0.6 + 0.2;
    final size = 30.0 + rng.nextDouble() * 50;

    final colors = [
      HomeScreen._cyanBlast,
      HomeScreen._hotPink,
      HomeScreen._electricPurple,
      HomeScreen._acidGreen,
      HomeScreen._laserRed,
      HomeScreen._solarYellow,
    ];
    final color = colors[widget.index % colors.length];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = math.sin(_controller.value * 2 * math.pi) * 20;
        final scale = 0.8 + math.sin(_controller.value * math.pi) * 0.2;

        return Positioned(
          left: left * MediaQuery.of(context).size.width - size / 2,
          top: (top * MediaQuery.of(context).size.height - size / 2) + offset,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//   COMIC ISSUE BADGE                                            
class _ComicIssueBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.05,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: HomeScreen._solarYellow,
          border: Border.all(color: HomeScreen._voidBlack, width: 3),
          boxShadow: [
            BoxShadow(
              color: HomeScreen._solarYellow.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: HomeScreen._voidBlack,
              offset: const Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          "ISSUE #001",
          style: TextStyle(
            color: HomeScreen._voidBlack,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontFamily: 'Courier',
          ),
        ),
      ),
    );
  }
}


//   NEON GLITCH TITLE                                            
class _NeonGlitchTitle extends StatefulWidget {
  final String text;
  final double fontSize;

  const _NeonGlitchTitle({
    required this.text,
    required this.fontSize,
  });

  @override
  State<_NeonGlitchTitle> createState() => _NeonGlitchTitleState();
}

class _NeonGlitchTitleState extends State<_NeonGlitchTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        final glitch = math.sin(_controller.value * 10) * 3;
        final glitch2 = math.cos(_controller.value * 15) * 2;

        return Stack(
          children: [
            // Chromatic aberration - Red channel
            Positioned(
              left: glitch,
              top: 0,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  color: HomeScreen._laserRed.withOpacity(0.7),
                  letterSpacing: 6,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            // Chromatic aberration - Cyan channel
            Positioned(
              left: -glitch,
              top: glitch2,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                  color: HomeScreen._cyanBlast.withOpacity(0.7),
                  letterSpacing: 6,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            // Main text with neon glow
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w900,
                color: HomeScreen._whiteOut,
                letterSpacing: 6,
                fontFamily: 'BebasNeue',
                shadows: [
                  Shadow(
                    color: HomeScreen._hotPink,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: HomeScreen._cyanBlast.withOpacity(0.8),
                    blurRadius: 40,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: HomeScreen._electricPurple,
                    blurRadius: 60,
                    offset: const Offset(0, 0),
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


//   TYPEWRITER SUBTITLE                                          
class _TypewriterSubtitle extends StatefulWidget {
  final String text;
  const _TypewriterSubtitle({required this.text});

  @override
  State<_TypewriterSubtitle> createState() => _TypewriterSubtitleState();
}

class _TypewriterSubtitleState extends State<_TypewriterSubtitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.rotate(
          angle: 0.02,
          child: Text(
            widget.text,
            style: TextStyle(
              color: HomeScreen._cyanBlast,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              fontFamily: 'Courier',
              shadows: [
                Shadow(
                  color: HomeScreen._cyanBlast.withOpacity(0.8),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _cursorController,
          builder: (context, child) {
            return Opacity(
              opacity: _cursorController.value,
              child: Container(
                width: 8,
                height: 14,
                margin: const EdgeInsets.only(left: 4),
                color: HomeScreen._acidGreen,
              ),
            );
          },
        ),
      ],
    );
  }
}


//   NEON QUOTE BOX                                               
class _NeonQuoteBox extends StatefulWidget {
  @override
  State<_NeonQuoteBox> createState() => _NeonQuoteBoxState();
}

class _NeonQuoteBoxState extends State<_NeonQuoteBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowIntensity = 0.5 + _glowController.value * 0.5;

        return Transform.rotate(
          angle: -0.02,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HomeScreen._deepVoid.withOpacity(0.9),
                  HomeScreen._voidBlack.withOpacity(0.95),
                ],
              ),
              border: Border.all(
                color: HomeScreen._cyanBlast.withOpacity(glowIntensity),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: HomeScreen._cyanBlast.withOpacity(0.3 * glowIntensity),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: HomeScreen._hotPink.withOpacity(0.2 * glowIntensity),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              children: [
                // Pulsing accent bar
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HomeScreen._solarYellow,
                        HomeScreen._hotPink,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HomeScreen._hotPink.withOpacity(glowIntensity),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⚡ SYSTEM ALERT",
                        style: TextStyle(
                          color: HomeScreen._acidGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Daily streak ready. Execute habits to power up! 🚀",
                        style: TextStyle(
                          color: HomeScreen._ghostWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated lightning icon
                Icon(
                  Icons.bolt,
                  color: HomeScreen._solarYellow.withOpacity(glowIntensity),
                  size: 28,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


//   HERO GIF ZONE - Perfect for your uploaded GIF!               
class _HeroGifZone extends StatelessWidget {
  final String? gifAssetPath;
  final AnimationController floatController;

  const _HeroGifZone({
    this.gifAssetPath,
    required this.floatController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background glow behind GIF
          Positioned(
            bottom: 20,
            child: AnimatedBuilder(
              animation: floatController,
              builder: (context, child) {
                final scale = 1 + math.sin(floatController.value * math.pi) * 0.1;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          HomeScreen._hotPink.withOpacity(0.4),
                          HomeScreen._electricPurple.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // GIF Container with comic book frame
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final offset = math.sin(floatController.value * 2 * math.pi) * 8;

              return Transform.translate(
                offset: Offset(0, offset),
                child: Container(
                  width: 380,
                  height: 200,
                  decoration: BoxDecoration(
                    // Comic book panel border
                    border: Border.all(
                      color: HomeScreen._whiteOut,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      // Neon glow
                      BoxShadow(
                        color: HomeScreen._cyanBlast.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                      // Hard shadow for comic effect
                      BoxShadow(
                        color: HomeScreen._voidBlack,
                        offset: const Offset(8, 8),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: gifAssetPath != null
                        ? Image.asset(
                            gifAssetPath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _PlaceholderCharacter();
                            },
                          )
                        : _PlaceholderCharacter(),
                  ),
                ),
              );
            },
          ),

          // Floating comic elements around GIF
          Positioned(
            top: 10,
            right: 20,
            child: _ComicBurst(text: "POW!"),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: _ComicBurst(text: "ZAP!"),
          ),

          // Halftone overlay on GIF area
          Positioned(
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      HomeScreen._electricPurple.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//   PLACEHOLDER CHARACTER (shown when no GIF)                    
class _PlaceholderCharacter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HomeScreen._hotPink.withOpacity(0.6),
            HomeScreen._electricPurple.withOpacity(0.4),
            HomeScreen._cyanBlast.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_fix_high,
              color: HomeScreen._whiteOut.withOpacity(0.8),
              size: 50,
            ),
            const SizedBox(height: 8),
            Text(
              "ADD GIF",
              style: TextStyle(
                color: HomeScreen._whiteOut.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//   COMIC BURST EFFECT                                           
class _ComicBurst extends StatelessWidget {
  final String text;
  const _ComicBurst({required this.text});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.Random().nextDouble() * 0.4 - 0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: HomeScreen._solarYellow,
          border: Border.all(color: HomeScreen._voidBlack, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: HomeScreen._voidBlack,
              offset: const Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: HomeScreen._voidBlack,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            fontFamily: 'BebasNeue',
          ),
        ),
      ),
    );
  }
}

//   NEON BUTTON ROW                                              
class _NeonButtonRow extends StatelessWidget {
  final Function(int) onNavigate;
  const _NeonButtonRow({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ButtonData(
        icon: Icons.dashboard_rounded,
        label: "DASH",
        color: HomeScreen._laserRed,
        index: 1,
      ),
      _ButtonData(
        icon: Icons.flag_rounded,
        label: "QUESTS",
        color: HomeScreen._electricPurple,
        index: 2,
      ),
      _ButtonData(
        icon: Icons.location_city_rounded,
        label: "CITY",
        color: HomeScreen._cyanBlast,
        index: 3,
      ),
      _ButtonData(
        icon: Icons.person_rounded,
        label: "HERO",
        color: HomeScreen._hotPink,
        index: 4,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((b) => _NeonButton(
        data: b,
        onTap: () => onNavigate(b.index),
      )).toList(),
    );
  }
}

class _ButtonData {
  final IconData icon;
  final String label;
  final Color color;
  final int index;

  _ButtonData({
    required this.icon,
    required this.label,
    required this.color,
    required this.index,
  });
}

class _NeonButton extends StatefulWidget {
  final _ButtonData data;
  final VoidCallback onTap;

  const _NeonButton({required this.data, required this.onTap});

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowIntensity = 0.6 + _glowController.value * 0.4;

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: Transform.rotate(
            angle: _pressed ? 0.03 : -0.03,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
              decoration: BoxDecoration(
                color: widget.data.color,
                border: Border.all(
                  color: HomeScreen._whiteOut,
                  width: _pressed ? 2 : 3,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Neon glow
                  BoxShadow(
                    color: widget.data.color.withOpacity(glowIntensity),
                    blurRadius: 20,
                    spreadRadius: _pressed ? 2 : 4,
                  ),
                  // Hard brutalist shadow
                  BoxShadow(
                    color: HomeScreen._voidBlack,
                    offset: Offset(_pressed ? 0 : 5, _pressed ? 0 : 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.data.icon,
                      color: HomeScreen._voidBlack,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.label,
                      style: TextStyle(
                        color: HomeScreen._voidBlack,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontFamily: 'BebasNeue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

//   CRT SCANLINE OVERLAY                                         
class _CRTPainter extends CustomPainter {
  final double scanPosition;

  _CRTPainter({required this.scanPosition});

  @override
  void paint(Canvas canvas, Size size) {
    // Scanline gradient
    final scanY = scanPosition * size.height;

    // Horizontal scanlines
    final linePaint = Paint()
      ..color = HomeScreen._voidBlack.withOpacity(0.1);

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, 2),
        linePaint,
      );
    }

    // Moving scan beam
    final beamGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        HomeScreen._cyanBlast.withOpacity(0.1),
        HomeScreen._cyanBlast.withOpacity(0.2),
        HomeScreen._cyanBlast.withOpacity(0.1),
        Colors.transparent,
      ],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, scanY - 50, size.width, 100),
      Paint()..shader = beamGradient.createShader(
        Rect.fromLTWH(0, scanY - 50, size.width, 100),
      ),
    );

    // Vignette corners
    final vignettePaint = Paint()
      ..color = HomeScreen._voidBlack.withOpacity(0.3);

    // Top vignette
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 60),
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HomeScreen._voidBlack.withOpacity(0.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 60)),
    );
  }

  @override
  bool shouldRepaint(covariant _CRTPainter oldDelegate) => true;
}
