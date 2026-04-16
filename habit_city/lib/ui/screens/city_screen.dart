import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const CityScreen({
    super.key,
    required this.onNavigate, 
  });

  @override
  State<CityScreen> createState() => _CityScreenState();
}

// The generic path for ANY manually created city
const List<CityTier> genericEvolutionPath = [
  CityTier(levelThreshold: 1, emoji: "⛺", title: "Camp"),
  CityTier(levelThreshold: 3, emoji: "🪵", title: "Cabin"),
  CityTier(levelThreshold: 5, emoji: "🏡", title: "Village"),
  CityTier(levelThreshold: 10, emoji: "🏬", title: "Town Center"),
  CityTier(levelThreshold: 15, emoji: "🏢", title: "City District"),
  CityTier(levelThreshold: 20, emoji: "🏙️", title: "Metropolis"),
];

// Custom path specifically for the "Gym" district
const List<CityTier> gymEvolutionPath = [
  CityTier(levelThreshold: 1, emoji: "👟", title: "Jogger"),
  CityTier(levelThreshold: 5, emoji: "🏋️", title: "Home Gym"),
  CityTier(levelThreshold: 10, emoji: "🥋", title: "Dojo"),
  CityTier(levelThreshold: 20, emoji: "🏟️", title: "Colosseum"),
];

class _CityScreenState extends State<CityScreen>
    with SingleTickerProviderStateMixin {

  // 🎨 Retro Futuristic Palette 
  static const _black    = Color(0xFF050508); 
  static const _void     = Color(0xFF0A0D14); 
  static const _neonBlue = Color(0xFF00F0FF); 
  static const _neonRed  = Color(0xFFFF003C); 
  static const _white    = Color(0xFFE0E5FF); 

  // City data initialized with the new XP evolution engine
  final List<_CityData> _cities = [
    _CityData(
      name: "Gym",
      icon: Icons.fitness_center_rounded,
      desc: "Train your body. Build raw power.",
      color: const Color(0xFFFF003C), // Neon Red
      tag: "BODY",
      isAuto: true,
      currentXp: 0,
      evolutionPath: gymEvolutionPath,
    ),
    _CityData(
      name: "Mind",
      icon: Icons.self_improvement_rounded,
      desc: "Meditate, reflect, stay sharp.",
      color: const Color(0xFFFF00FF), // Magenta
      tag: "MENTAL",
      isAuto: true,
      currentXp: 0,
      evolutionPath: genericEvolutionPath,
    ),
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    // Faster, breathing pulse for the living city
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
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
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return _CityDetailSheet(
            city: city,
            onTaskComplete: () {
              // Add 25 XP when clicked!
              setState(() {
                city.currentXp += 25;
              });
              setModalState(() {}); // Re-render bottom sheet live
            },
          );
        }
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
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
                    "CITY GRID",
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _neonBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _neonBlue.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      "${_cities.length} DISTRICTS",
                      style: const TextStyle(
                        color: _neonBlue,
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
          Positioned.fill(child: CustomPaint(painter: _CyberGridPainter())),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _CitySkylineBanner(
                  totalCities: _cities.length,
                  avgLevel: "0.0", 
                  pulseAnim: _pulseAnim,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 16,
                        decoration: BoxDecoration(
                          color: _neonRed,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [BoxShadow(color: _neonRed.withOpacity(0.8), blurRadius: 6)],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "ACTIVE DISTRICTS",
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _NewCityTile(onTap: _addNewCity),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85, 
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) {
                        return _CityTile(
                          data: _cities[index],
                          pulseValue: _pulseAnim.value,
                          onTap: () => _openCity(_cities[index]),
                        );
                      }
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

// City skyline banner 
class _CitySkylineBanner extends StatelessWidget {
  final int totalCities;
  final String avgLevel;
  final Animation<double> pulseAnim;

  static const _void     = Color(0xFF0A0D14); 
  static const _neonBlue = Color(0xFF00F0FF); 
  static const _neonRed  = Color(0xFFFF003C); 
  static const _white    = Color(0xFFE0E5FF); 

  const _CitySkylineBanner({
    required this.totalCities,
    required this.avgLevel,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 130, 
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _void,
        border: Border.all(color: _neonBlue.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 24),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _BannerLinePainter()),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 55),
              painter: _SkylinePainter(),
            ),
          ),
          Positioned(
            right: 20, top: 20,
            child: AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: 0.8 + (pulseAnim.value * 0.2),
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _neonRed.withOpacity(0.2 * pulseAnim.value),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "HABIT METROPOLIS",
                      style: TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Complete protocols to evolve the grid.",
                      style: TextStyle(
                        color: _neonBlue.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _BannerStat(
                        label: "DISTRICTS",
                        value: "$totalCities",
                        color: _neonBlue),
                    const SizedBox(width: 10),
                    _BannerStat(
                        label: "AVG LEVEL",
                        value: avgLevel,
                        color: _neonRed),
                    const SizedBox(width: 10),
                    _BannerStat(
                        label: "STATUS",
                        value: "AWAITING DATA",
                        color: Colors.amberAccent),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewCityTile extends StatelessWidget {
  final VoidCallback onTap;

  static const _neonBlue = Color(0xFF00F0FF);
  static const _void     = Color(0xFF0A0D14);

  const _NewCityTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _neonBlue.withOpacity(0.5), width: 1.5),
          color: _void,
          boxShadow: [
            BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 12),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_box_rounded, color: _neonBlue, size: 20),
            const SizedBox(width: 10),
            Text(
              "INITIALIZE NEW DISTRICT",
              style: TextStyle(
                color: _neonBlue.withOpacity(0.9),
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

class _CityTile extends StatelessWidget {
  final _CityData data;
  final double pulseValue;
  final VoidCallback onTap;

  static const _void  = Color(0xFF0A0D14);
  static const _white = Color(0xFFE0E5FF);

  const _CityTile({
    required this.data, 
    required this.pulseValue, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final double currentGlow = 4 + (12 * pulseValue);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _void,
          border: Border.all(
            color: data.color.withOpacity(0.4 + (0.2 * pulseValue)),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.15 * pulseValue),
              blurRadius: currentGlow,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        data.color.withOpacity(0.1 * pulseValue),
                        Colors.transparent,
                      ]
                    )
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: data.color.withOpacity(0.5), width: 1.2),
                          ),
                          child: Center(
                            child: Text(data.currentTier.emoji, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: data.color.withOpacity(0.5), width: 1),
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
                    const SizedBox(height: 12),
                    Text(
                      data.name.toUpperCase(),
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.desc,
                      style: TextStyle(
                        color: _white.withOpacity(0.5),
                        fontSize: 10,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: data.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: data.color.withOpacity(0.3), width: 1),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PROGRESS",
                              style: TextStyle(
                                color: _white.withOpacity(0.4),
                                fontSize: 8,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${(data.progress * 100).round()}%",
                              style: TextStyle(
                                color: data.color,
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
                            minHeight: 4,
                            backgroundColor: data.color.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation(data.color),
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

class _CityDetailSheet extends StatelessWidget {
  final _CityData city;
  final VoidCallback onTaskComplete;

  static const _black    = Color(0xFF050508);
  static const _white    = Color(0xFFE0E5FF);
  static const _neonBlue = Color(0xFF00F0FF);

  const _CityDetailSheet({required this.city, required this.onTaskComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: city.color.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: city.color.withOpacity(0.2), blurRadius: 30),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: city.color.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  color: city.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: city.color.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: city.color.withOpacity(0.3), blurRadius: 16),
                  ],
                ),
                child: Center(
                  child: Text(city.currentTier.emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${city.name.toUpperCase()} [${city.currentTier.title.toUpperCase()}]",
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      city.desc,
                      style: TextStyle(
                        color: _white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: city.color.withOpacity(0.1),
                  border: Border.all(color: city.color, width: 2),
                  boxShadow: [
                    BoxShadow(color: city.color.withOpacity(0.4), blurRadius: 14),
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
          Text(
            "UPGRADE PROTOCOL",
            style: TextStyle(
              color: _white.withOpacity(0.4),
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(10, (i) {
              final filled = i < (city.progress * 10).round();
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 9 ? 3 : 0),
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: filled ? city.color : city.color.withOpacity(0.1),
                    boxShadow: filled ? [BoxShadow(color: city.color.withOpacity(0.5), blurRadius: 6)] : null,
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
                color: city.color.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _SheetStat(label: "MISSIONS", value: "0", color: city.color),
              const SizedBox(width: 10),
              _SheetStat(label: "STREAK", value: "0d 🔥", color: Colors.grey),
              const SizedBox(width: 10),
              _SheetStat(label: "TOTAL XP", value: "${city.currentXp}", color: _neonBlue),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onTaskComplete, // Wire up the XP button
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: city.color.withOpacity(0.1),
                border: Border.all(color: city.color, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: city.color.withOpacity(0.3), blurRadius: 15),
                ],
              ),
              child: Center(
                child: Text(
                  "⚡ EXECUTE TASK (+25 XP)",
                  style: TextStyle(
                    color: city.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
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
          border: Border.all(color: color.withOpacity(0.25), width: 1),
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
                color: _white.withOpacity(0.4),
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

class _NewCitySheet extends StatefulWidget {
  final void Function(_CityData) onAdd;
  const _NewCitySheet({required this.onAdd});

  @override
  State<_NewCitySheet> createState() => _NewCitySheetState();
}

class _NewCitySheetState extends State<_NewCitySheet> {
  static const _white    = Color(0xFFE0E5FF);
  static const _black    = Color(0xFF050508);
  static const _neonBlue = Color(0xFF00F0FF);
  static const _neonRed  = Color(0xFFFF003C);

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _selectedEmoji = "🏙️";
  Color _selectedColor  = const Color(0xFF00F0FF);
  String _selectedTag   = "CUSTOM";

  final _emojis = ["🏙️","⚔️","🎵","💻","🌿","🧪","🏄","🎭","🌙","🚀"];
  final _colors = [
    const Color(0xFF00F0FF), 
    const Color(0xFFFF003C), 
    const Color(0xFFFF00FF), 
    const Color(0xFF00FFAA), 
    Colors.orangeAccent,
    Colors.yellowAccent,
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
        color: _black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _neonBlue.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: _neonBlue.withOpacity(0.2), blurRadius: 30),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: _neonBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "FOUND NEW DISTRICT",
              style: TextStyle(
                color: _neonBlue,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Initialize parameters for the new zone.",
              style: TextStyle(color: _white.withOpacity(0.5), fontSize: 12),
            ),
            const SizedBox(height: 20),
            _GlowTextField(
              controller: _nameCtrl,
              hint: "District name...",
              color: _neonBlue,
            ),
            const SizedBox(height: 12),
            _GlowTextField(
              controller: _descCtrl,
              hint: "Short description...",
              color: _neonRed,
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: "SELECT ICON"),
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
                      color: sel ? _selectedColor.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? _selectedColor : _white.withOpacity(0.1),
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
            const _SectionLabel(label: "DISTRICT COLOR"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: _colors.map((c) {
                final sel = c == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.withOpacity(sel ? 1.0 : 0.5),
                      border: Border.all(
                        color: sel ? Colors.white : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: sel ? [BoxShadow(color: c.withOpacity(0.8), blurRadius: 12)] : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: "CATEGORY TAG"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _tags.map((t) {
                final sel = t == _selectedTag;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTag = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? _selectedColor.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: sel ? _selectedColor : _white.withOpacity(0.2),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        color: sel ? _selectedColor : _white.withOpacity(0.5),
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
            GestureDetector(
              onTap: () {
                if (_nameCtrl.text.trim().isEmpty) return;
                
                // Construct the newly configured _CityData
                widget.onAdd(_CityData(
                  name: _nameCtrl.text.trim(),
                  icon: Icons.location_city_rounded,
                  desc: _descCtrl.text.trim().isEmpty
                      ? "A new district in your grid."
                      : _descCtrl.text.trim(),
                  color: _selectedColor,
                  tag: _selectedTag,
                  isAuto: false, // Manual city
                  currentXp: 0,
                  // Uses the selected emoji as the starting point, but follows generic rules
                  evolutionPath: [
                    CityTier(levelThreshold: 1, emoji: _selectedEmoji, title: "Base"),
                    ...genericEvolutionPath.skip(1), // Adds the rest of the generic path
                  ],
                ));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.1),
                  border: Border.all(color: _selectedColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: _selectedColor.withOpacity(0.3), blurRadius: 15),
                  ],
                ),
                child: Center(
                  child: Text(
                    "COMPILE DISTRICT",
                    style: TextStyle(
                      color: _selectedColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
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

class _GlowTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color color;
  const _GlowTextField(
      {required this.controller, required this.hint, required this.color});

  static const _white = Color(0xFFE0E5FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF0A0D14),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _white, fontSize: 14),
        cursorColor: color,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _white.withOpacity(0.3), fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  static const _white = Color(0xFFE0E5FF);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: _white.withOpacity(0.4),
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// THE NEW DATA MODEL (Replaces old _CityData entirely)
class CityTier {
  final int levelThreshold;
  final String emoji;
  final String title;

  const CityTier({
    required this.levelThreshold,
    required this.emoji,
    required this.title,
  });
}

class _CityData {
  final String name;
  final IconData icon;
  final String desc;
  final Color color;
  final String tag;
  final bool isAuto; 
  
  // Dynamic stats
  int currentXp;
  final int xpPerLevel; 
  
  final List<CityTier> evolutionPath;

  _CityData({
    required this.name,
    required this.icon,
    required this.desc,
    required this.color,
    required this.tag,
    this.isAuto = false,
    this.currentXp = 0,
    this.xpPerLevel = 100,
    required this.evolutionPath,
  });

  int get level => (currentXp ~/ xpPerLevel) + 1; 
  
  double get progress => (currentXp % xpPerLevel) / xpPerLevel;

  CityTier get currentTier {
    CityTier activeTier = evolutionPath.first;
    for (var tier in evolutionPath) {
      if (level >= tier.levelThreshold) {
        activeTier = tier;
      } else {
        break;
      }
    }
    return activeTier;
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF050508),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.04)
      ..strokeWidth = 1.0;

    const gap = 30.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _BannerLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
      
    const cx = 0.0;
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
  double _cos(double a) => (a < 3.14159) ? -1 + 2 * a / 3.14159 : 1 - 2 * (a - 3.14159) / 3.14159;
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
      ..color = const Color(0xFF00F0FF).withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

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

    final winPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.3);
    final rng = [0.08, 0.18, 0.30, 0.40, 0.54, 0.63, 0.74, 0.83, 0.93];
    for (final x in rng) {
      for (double y = 0.3; y < 0.85; y += 0.18) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width * x, size.height * y),
            width: 2, height: 3,
          ),
          winPaint,
        );
      }
    }
  }
  @override
  bool shouldRepaint(_) => false;
}