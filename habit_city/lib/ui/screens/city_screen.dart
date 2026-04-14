import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  // 1. Add the onNavigate callback
  final Function(int) onNavigate;

  const CityScreen({
    super.key,
    required this.onNavigate, // Make it required
  });

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen>
    with SingleTickerProviderStateMixin {

  //  Palette 
  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFE040FB);
  static const _white      = Color(0xFFF0E6FF);

  //  City data 
  final List<_CityData> _cities = [
    _CityData(
      name: "Gym",
      emoji: "🏋️",
      icon: Icons.fitness_center_rounded,
      desc: "Train your body. Build raw power.",
      color: Colors.orangeAccent,
      level: 3,
      progress: 0.65,
      tag: "BODY",
    ),
    _CityData(
      name: "Library",
      emoji: "📚",
      icon: Icons.menu_book_rounded,
      desc: "Expand your knowledge every day.",
      color: const Color(0xFF6EC6F5),
      level: 5,
      progress: 0.40,
      tag: "KNOWLEDGE",
    ),
    _CityData(
      name: "Mind",
      emoji: "🧠",
      icon: Icons.self_improvement_rounded,
      desc: "Meditate, reflect, stay sharp.",
      color: const Color(0xFFE040FB),
      level: 2,
      progress: 0.20,
      tag: "MENTAL",
    ),
    _CityData(
      name: "Health",
      emoji: "❤️",
      icon: Icons.favorite_rounded,
      desc: "Sleep, hydration, and nutrition.",
      color: const Color(0xFFCC1C3A),
      level: 4,
      progress: 0.80,
      tag: "HEALTH",
    ),
    _CityData(
      name: "Study",
      emoji: "✏️",
      icon: Icons.school_rounded,
      desc: "Deep work sessions and skill mastery.",
      color: Colors.greenAccent,
      level: 1,
      progress: 0.10,
      tag: "SKILL",
    ),
    _CityData(
      name: "Focus",
      emoji: "🎯",
      icon: Icons.track_changes_rounded,
      desc: "Lock in. No distractions. Pure output.",
      color: Colors.yellowAccent,
      level: 2,
      progress: 0.35,
      tag: "FLOW",
    ),
    _CityData(
      name: "Hobby",
      emoji: "🎨",
      icon: Icons.palette_rounded,
      desc: "Create for joy. Explore your passions.",
      color: const Color(0xFF7B2FBE),
      level: 1,
      progress: 0.55,
      tag: "CREATIVE",
    ),
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openCity(_CityData city) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CityDetailSheet(city: city),
    );
  }

  void _addNewCity() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NewCitySheet(
        onAdd: (city) {
          setState(() => _cities.add(city));
          Navigator.pop(context);
        },
      ),
    );
  }

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
                  // 2. Updated Home Button
                  GestureDetector(
                    onTap: () => widget.onNavigate(0), // Navigates to Home
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _red, // Consistent red home button
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _red.withOpacity(0.7), blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.home_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "YOUR CITY",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // City count
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _purple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: _purple.withOpacity(0.4), width: 1),
                    ),
                    child: Text(
                      "${_cities.length} DISTRICTS",
                      style: const TextStyle(
                        color: _purple,
                        fontSize: 10,
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
          // Background
          Positioned.fill(child: CustomPaint(painter: _CityBgPainter())),

          CustomScrollView(
            slivers: [

              //  City skyline hero 
              SliverToBoxAdapter(
                child: _CitySkylineBanner(
                  totalCities: _cities.length,
                  avgLevel: (_cities.fold(0, (s, c) => s + c.level) /
                      _cities.length).toStringAsFixed(1),
                  pulseAnim: _pulseAnim,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              //  Section label 
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 16,
                        decoration: BoxDecoration(
                          color: _liteBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "DISTRICTS",
                        style: TextStyle(
                          color: _white.withOpacity(0.55),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              //  NEW CITY tile (top) 
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _NewCityTile(onTap: _addNewCity),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              //  City grid 
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _CityTile(
                      data: _cities[index],
                      onTap: () => _openCity(_cities[index]),
                    ),
                    childCount: _cities.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  City skyline banner 
class _CitySkylineBanner extends StatelessWidget {
  final int totalCities;
  final String avgLevel;
  final Animation<double> pulseAnim;

  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _red        = Color(0xFFCC1C3A);
  static const _liteBlue   = Color(0xFF6EC6F5);
  static const _pink       = Color(0xFFE040FB);
  static const _white      = Color(0xFFF0E6FF);

  const _CitySkylineBanner({
    required this.totalCities,
    required this.avgLevel,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 140,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E0040), Color(0xFF0D001A)],
        ),
        border: Border.all(color: _purple.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.2), blurRadius: 24),
        ],
      ),
      child: Stack(
        children: [
          // Speed lines
          Positioned.fill(
            child: CustomPaint(painter: _BannerLinePainter()),
          ),

          // Pixel city skyline silhouette
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 55),
              painter: _SkylinePainter(),
            ),
          ),

          // Pulsing glow orb
          Positioned(
            right: 20, top: 20,
            child: AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _pink.withOpacity(0.18),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top: title + tagline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "HABIT CITY",
                      style: TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Build your empire. One habit at a time.",
                      style: TextStyle(
                        color: _liteBlue.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Bottom: stat chips
                Row(
                  children: [
                    _BannerStat(
                        label: "DISTRICTS",
                        value: "$totalCities",
                        color: _liteBlue),
                    const SizedBox(width: 10),
                    _BannerStat(
                        label: "AVG LEVEL",
                        value: avgLevel,
                        color: _pink),
                    const SizedBox(width: 10),
                    _BannerStat(
                        label: "STATUS",
                        value: "ACTIVE",
                        color: Colors.greenAccent),
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

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _BannerStat(
      {required this.label, required this.value, required this.color});

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
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.6),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

//  New city tile (top CTA) 
class _NewCityTile extends StatelessWidget {
  final VoidCallback onTap;

  static const _purple   = Color(0xFF7B2FBE);
  static const _liteBlue = Color(0xFF6EC6F5);
  static const _white    = Color(0xFFF0E6FF);

  const _NewCityTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _liteBlue.withOpacity(0.45),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              _purple.withOpacity(0.08),
              _liteBlue.withOpacity(0.06),
            ],
          ),
          boxShadow: [
            BoxShadow(color: _liteBlue.withOpacity(0.08), blurRadius: 16),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _liteBlue.withOpacity(0.12),
                border: Border.all(color: _liteBlue.withOpacity(0.4), width: 1),
              ),
              child: Icon(Icons.add_rounded, color: _liteBlue, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "FOUND A NEW DISTRICT",
              style: TextStyle(
                color: _liteBlue.withOpacity(0.9),
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  City tile 
class _CityTile extends StatelessWidget {
  final _CityData data;
  final VoidCallback onTap;

  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _white      = Color(0xFFF0E6FF);

  const _CityTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _deepPurple.withOpacity(0.7),
              Colors.black.withOpacity(0.5),
            ],
          ),
          border: Border.all(
            color: data.color.withOpacity(0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.12),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Corner halftone
              Positioned(
                top: 0, right: 0,
                width: 60, height: 60,
                child: CustomPaint(
                  painter: _SmallHalftonePainter(
                    color: data.color.withOpacity(0.12),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Icon + level badge row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: data.color.withOpacity(0.4), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                  color: data.color.withOpacity(0.2),
                                  blurRadius: 10),
                            ],
                          ),
                          child: Center(
                            child: Text(data.emoji,
                                style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: data.color.withOpacity(0.4), width: 1),
                          ),
                          child: Text(
                            "LV.${data.level}",
                            style: TextStyle(
                              color: data.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Name
                    Text(
                      data.name.toUpperCase(),
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Desc
                    Text(
                      data.desc,
                      style: TextStyle(
                        color: _white.withOpacity(0.4),
                        fontSize: 10,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Tag pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: data.color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: data.color.withOpacity(0.3), width: 1),
                      ),
                      child: Text(
                        data.tag,
                        style: TextStyle(
                          color: data.color.withOpacity(0.9),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PROGRESS",
                              style: TextStyle(
                                color: _white.withOpacity(0.3),
                                fontSize: 8,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${(data.progress * 100).round()}%",
                              style: TextStyle(
                                color: data.color.withOpacity(0.8),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LinearProgressIndicator(
                            value: data.progress,
                            minHeight: 5,
                            backgroundColor: data.color.withOpacity(0.1),
                            valueColor:
                                AlwaysStoppedAnimation(data.color),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  City detail bottom sheet 
class _CityDetailSheet extends StatelessWidget {
  final _CityData city;

  static const _black      = Color(0xFF0A0008);
  static const _deepPurple = Color(0xFF2D0057);
  static const _purple     = Color(0xFF7B2FBE);
  static const _white      = Color(0xFFF0E6FF);
  static const _liteBlue   = Color(0xFF6EC6F5);

  const _CityDetailSheet({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0018),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: city.color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: city.color.withOpacity(0.2), blurRadius: 30),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: city.color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  color: city.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: city.color.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: city.color.withOpacity(0.25), blurRadius: 16),
                  ],
                ),
                child: Center(
                  child: Text(city.emoji,
                      style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name.toUpperCase(),
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      city.desc,
                      style: TextStyle(
                        color: _white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Level orb
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    city.color.withOpacity(0.3),
                    city.color.withOpacity(0.05),
                  ]),
                  border: Border.all(color: city.color, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: city.color.withOpacity(0.4), blurRadius: 14),
                  ],
                ),
                child: Center(
                  child: Text(
                    "LV\n${city.level}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: city.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress section
          Text(
            "DISTRICT PROGRESS",
            style: TextStyle(
              color: _white.withOpacity(0.35),
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          // Segmented bar
          Row(
            children: List.generate(10, (i) {
              final filled = i < (city.progress * 10).round();
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 9 ? 3 : 0),
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: filled
                        ? city.color
                        : city.color.withOpacity(0.08),
                    boxShadow: filled
                        ? [
                            BoxShadow(
                              color: city.color.withOpacity(0.4),
                              blurRadius: 6,
                            )
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(city.progress * 100).round()}% to LV.${city.level + 1}",
              style: TextStyle(
                color: city.color.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Stat row
          Row(
            children: [
              _SheetStat(label: "MISSIONS", value: "12", color: city.color),
              const SizedBox(width: 10),
              _SheetStat(label: "STREAK", value: "7d 🔥", color: Colors.orangeAccent),
              const SizedBox(width: 10),
              _SheetStat(label: "TOTAL XP", value: "340", color: _liteBlue),
            ],
          ),

          const SizedBox(height: 24),

          // Evolve button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [city.color, city.color.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: city.color.withOpacity(0.4), blurRadius: 18),
                ],
              ),
              child: const Center(
                child: Text(
                  "⚡  EVOLVE DISTRICT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 2,
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

class _SheetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SheetStat(
      {required this.label, required this.value, required this.color});

  static const _white = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: _white.withOpacity(0.35),
                fontSize: 8,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  New city bottom sheet 
class _NewCitySheet extends StatefulWidget {
  final void Function(_CityData) onAdd;
  const _NewCitySheet({required this.onAdd});

  @override
  State<_NewCitySheet> createState() => _NewCitySheetState();
}

class _NewCitySheetState extends State<_NewCitySheet> {
  static const _white    = Color(0xFFF0E6FF);
  static const _purple   = Color(0xFF7B2FBE);
  static const _liteBlue = Color(0xFF6EC6F5);
  static const _red      = Color(0xFFCC1C3A);

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _selectedEmoji = "🏙️";
  Color _selectedColor  = const Color(0xFF7B2FBE);
  String _selectedTag   = "CUSTOM";

  final _emojis = ["🏙️","⚔️","🎵","💻","🌿","🧪","🏄","🎭","🌙","🚀"];
  final _colors = [
    const Color(0xFF7B2FBE),
    const Color(0xFF6EC6F5),
    const Color(0xFFCC1C3A),
    const Color(0xFFE040FB),
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.tealAccent,
  ];
  final _tags = ["CUSTOM","SPORT","ART","TECH","NATURE","SOCIAL","SPIRIT","FINANCE"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0018),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _liteBlue.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(color: _purple.withOpacity(0.2), blurRadius: 30),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: _liteBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "FOUND NEW DISTRICT",
              style: TextStyle(
                color: _white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Choose an identity for your new city.",
              style: TextStyle(color: _white.withOpacity(0.4), fontSize: 12),
            ),

            const SizedBox(height: 20),

            // Name field
            _GlowTextField(
              controller: _nameCtrl,
              hint: "District name...",
              color: _liteBlue,
            ),

            const SizedBox(height: 12),

            // Desc field
            _GlowTextField(
              controller: _descCtrl,
              hint: "Short description...",
              color: _purple,
            ),

            const SizedBox(height: 20),

            // Emoji picker
            _SectionLabel(label: "PICK AN ICON"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _emojis.map((e) {
                final sel = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: sel
                          ? _selectedColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel
                            ? _selectedColor
                            : Colors.white.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Color picker
            _SectionLabel(label: "DISTRICT COLOR"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _colors.map((c) {
                final sel = c == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c,
                      border: Border.all(
                        color: sel ? Colors.white : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: sel
                          ? [BoxShadow(color: c.withOpacity(0.6), blurRadius: 10)]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Tag picker
            _SectionLabel(label: "CATEGORY TAG"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _tags.map((t) {
                final sel = t == _selectedTag;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTag = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel
                          ? _selectedColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: sel
                            ? _selectedColor
                            : Colors.white.withOpacity(0.12),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        color: sel ? _selectedColor : _white.withOpacity(0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Create button
            GestureDetector(
              onTap: () {
                if (_nameCtrl.text.trim().isEmpty) return;
                widget.onAdd(_CityData(
                  name: _nameCtrl.text.trim(),
                  emoji: _selectedEmoji,
                  icon: Icons.location_city_rounded,
                  desc: _descCtrl.text.trim().isEmpty
                      ? "A new district in your city."
                      : _descCtrl.text.trim(),
                  color: _selectedColor,
                  level: 1,
                  progress: 0.0,
                  tag: _selectedTag,
                ));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_selectedColor, _selectedColor.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: _selectedColor.withOpacity(0.4), blurRadius: 18),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "🏙️  FOUND DISTRICT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 2,
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

//  Glow text field 
class _GlowTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color color;
  const _GlowTextField(
      {required this.controller, required this.hint, required this.color});

  static const _white = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: _white.withOpacity(0.25), fontSize: 13),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

//  Section label 
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  static const _white = Color(0xFFF0E6FF);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: _white.withOpacity(0.35),
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

//  Data model 
class _CityData {
  final String name;
  final String emoji;
  final IconData icon;
  final String desc;
  final Color color;
  final int level;
  final double progress;
  final String tag;

  const _CityData({
    required this.name,
    required this.emoji,
    required this.icon,
    required this.desc,
    required this.color,
    required this.level,
    required this.progress,
    required this.tag,
  });
}

//  Painters 
class _CityBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0008),
    );
    final paint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final cx = size.width * 0.5;
    final cy = size.height * 1.2;
    for (int i = 0; i < 24; i++) {
      final a = (i / 24) * 3.14159 * 2;
      final ex = cx + size.height * 1.5 * _cos(a);
      final ey = cy + size.height * 1.5 * _sin(a);
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), paint);
    }
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.15),
      size.width * 0.35,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF6EC6F5).withOpacity(0.08),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.15),
          radius: size.width * 0.35,
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

class _BannerLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final cx = size.width * 0.9;
    final cy = size.height * 0.5;
    for (int i = 0; i < 18; i++) {
      final a = (i / 18) * 3.14159 * 2;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + size.width * _cos(a), cy + size.width * _sin(a)),
        paint,
      );
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

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B2FBE).withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    // Hand-crafted silhouette buildings
    final buildings = [
      [0.0, 1.0], [0.0, 0.55], [0.06, 0.55], [0.06, 0.35],
      [0.10, 0.35],[0.10, 0.45],[0.16, 0.45],[0.16, 0.2],
      [0.19, 0.2], [0.19, 0.4], [0.24, 0.4], [0.24, 0.6],
      [0.28, 0.6], [0.28, 0.3], [0.33, 0.3], [0.33, 0.5],
      [0.38, 0.5], [0.38, 0.15],[0.42, 0.15],[0.42, 0.45],
      [0.48, 0.45],[0.48, 0.55],[0.53, 0.55],[0.53, 0.25],
      [0.57, 0.25],[0.57, 0.4], [0.62, 0.4], [0.62, 0.6],
      [0.66, 0.6], [0.66, 0.3], [0.72, 0.3], [0.72, 0.5],
      [0.77, 0.5], [0.77, 0.2], [0.81, 0.2], [0.81, 0.45],
      [0.86, 0.45],[0.86, 0.65],[0.91, 0.65],[0.91, 0.35],
      [0.95, 0.35],[0.95, 0.55],[1.0, 0.55], [1.0, 1.0],
    ];

    for (final b in buildings) {
      path.lineTo(size.width * b[0], size.height * b[1]);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Window dots
    final winPaint = Paint()
      ..color = const Color(0xFF6EC6F5).withOpacity(0.3);
    final rng = [0.08, 0.18, 0.30, 0.40, 0.54, 0.63, 0.74, 0.83, 0.93];
    for (final x in rng) {
      for (double y = 0.3; y < 0.85; y += 0.18) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width * x, size.height * y),
            width: 3, height: 4,
          ),
          winPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _SmallHalftonePainter extends CustomPainter {
  final Color color;
  const _SmallHalftonePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const gap = 8.0;
    const r   = 1.8;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}