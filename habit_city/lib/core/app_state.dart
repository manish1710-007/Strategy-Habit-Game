import 'package:flutter/material.dart';

//  City evolution tiers 
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

const List<CityTier> genericEvolutionPath = [
  CityTier(levelThreshold: 1,  emoji: "⛺",  title: "Camp"),
  CityTier(levelThreshold: 3,  emoji: "🪵",  title: "Cabin"),
  CityTier(levelThreshold: 5,  emoji: "🏡",  title: "Village"),
  CityTier(levelThreshold: 10, emoji: "🏬",  title: "Town Center"),
  CityTier(levelThreshold: 15, emoji: "🏢",  title: "City District"),
  CityTier(levelThreshold: 20, emoji: "🏙️", title: "Metropolis"),
];

const List<CityTier> gymEvolutionPath = [
  CityTier(levelThreshold: 1,  emoji: "👟",  title: "Jogger"),
  CityTier(levelThreshold: 5,  emoji: "🏋️", title: "Home Gym"),
  CityTier(levelThreshold: 10, emoji: "🥋",  title: "Dojo"),
  CityTier(levelThreshold: 20, emoji: "🏟️", title: "Colosseum"),
];

const List<CityTier> libraryEvolutionPath = [
  CityTier(levelThreshold: 1,  emoji: "📖",  title: "Reading Nook"),
  CityTier(levelThreshold: 5,  emoji: "📚",  title: "Library"),
  CityTier(levelThreshold: 10, emoji: "🏛️", title: "Archive"),
  CityTier(levelThreshold: 20, emoji: "🔭",  title: "Academy"),
];

const List<CityTier> mindEvolutionPath = [
  CityTier(levelThreshold: 1,  emoji: "🕯️", title: "Altar"),
  CityTier(levelThreshold: 5,  emoji: "🧘",  title: "Dojo"),
  CityTier(levelThreshold: 10, emoji: "🧠",  title: "Mind Palace"),
  CityTier(levelThreshold: 20, emoji: "⚡",  title: "Singularity"),
];

//  City data model (lives in GameEngine, not CityScreen) 
class CityData extends ChangeNotifier {
  final String name;
  final IconData icon;
  final String desc;
  final Color color;
  final String tag;
  final bool isAuto;
  final List<CityTier> evolutionPath;
  final int xpPerLevel;

  int currentXp;

  CityData({
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

  int get level    => (currentXp ~/ xpPerLevel) + 1;
  double get progress => (currentXp % xpPerLevel) / xpPerLevel;

  CityTier get currentTier {
    CityTier active = evolutionPath.first;
    for (final tier in evolutionPath) {
      if (level >= tier.levelThreshold) {
        active = tier;
      } else {
        break;
      }
    }
    return active;
  }

  void addXp(int amount) {
    currentXp += amount;
  }
}

//  GameEngine — single source of truth 
class GameEngine extends ChangeNotifier {
  //  Global player stats 
  int _xp     = 0;
  int _energy = 100;
  int _completedHabits = 0;
  int _streakDays = 0; // wire to date logic later

  int get xp              => _xp;
  int get energy          => _energy;
  int get completedHabits => _completedHabits;
  int get streakDays      => _streakDays;

  int get level       => (_xp ~/ 100) + 1;
  int get currentXP   => _xp % 100;
  double get xpProgress => currentXP / 100.0;

  String get rankLabel {
    if (level < 3)  return "ROOKIE";
    if (level < 6)  return "HUNTER";
    if (level < 10) return "VETERAN";
    return "LEGEND";
  }

  //  City districts (global, persistent across screens) 
  final List<CityData> cities = [
    CityData(
      name: "Gym",
      icon: Icons.fitness_center_rounded,
      desc: "Train your body. Build raw power.",
      color: const Color(0xFFFF003C),
      tag: "BODY",
      isAuto: true,
      evolutionPath: gymEvolutionPath,
    ),
    CityData(
      name: "Library",
      icon: Icons.menu_book_rounded,
      desc: "Expand your knowledge every day.",
      color: const Color(0xFF00F0FF),
      tag: "KNOWLEDGE",
      isAuto: true,
      evolutionPath: libraryEvolutionPath,
    ),
    CityData(
      name: "Mind",
      icon: Icons.self_improvement_rounded,
      desc: "Meditate, reflect, stay sharp.",
      color: const Color(0xFFFF00FF),
      tag: "MENTAL",
      isAuto: true,
      evolutionPath: mindEvolutionPath,
    ),
    CityData(
      name: "Health",
      icon: Icons.favorite_rounded,
      desc: "Sleep, hydration, and nutrition.",
      color: const Color(0xFF00FFAA),
      tag: "HEALTH",
      isAuto: true,
      evolutionPath: genericEvolutionPath,
    ),
  ];

  //  XP routing map: city tag → city name 
  // When a habit is completed, its tag routes XP to the matching city.
  // Falls back to all cities (global XP spill) if no match.
  static const Map<String, String> _tagToCityName = {
    "BODY":      "Gym",
    "HEALTH":    "Health",
    "KNOWLEDGE": "Library",
    "GROWTH":    "Library",
    "MENTAL":    "Mind",
    "MIND":      "Mind",
    "SKILL":     "Library",
    "FLOW":      "Mind",
  };

  //  Core habit completion method 
  // Call this from DashboardScreen when a habit is completed.
  // Returns the old level so the caller can detect a level-up.
  int completeHabit({required int difficulty, String habitTag = "GENERAL"}) {
    final oldLevel = level;
    final gainedXP = difficulty * 10;

    _xp     += gainedXP;
    _energy += difficulty * 5;
    _completedHabits++;

    // Route XP to matching city (25 XP per completion)
    final cityName = _tagToCityName[habitTag.toUpperCase()];
    if (cityName != null) {
      final city = cities.firstWhere(
        (c) => c.name == cityName,
        orElse: () => cities.first,
      );
      city.addXp(25);
    } else {
      // No match → distribute 10 XP across all auto cities
      for (final city in cities.where((c) => c.isAuto)) {
        city.addXp(10);
      }
    }

    notifyListeners();
    return oldLevel;
  }

  //  Called from CityScreen "EXECUTE TASK" button 
  void addCityXp(CityData city, int amount) {
    city.addXp(amount);
    notifyListeners();
  }

  //  Called from DashboardScreen directly (legacy support) 
  void addXP(int amount) {
    _xp += amount;
    notifyListeners();
  }

  void addEnergy(int amount) {
    _energy += amount;
    notifyListeners();
  }

  //  Add a new user-created city 
  void addCity(CityData city) {
    cities.add(city);
    notifyListeners();
  }

  //  Computed city stats for banner 
  String get avgCityLevel {
    if (cities.isEmpty) return "0.0";
    final avg = cities.fold(0, (s, c) => s + c.level) / cities.length;
    return avg.toStringAsFixed(1);
  }

  int get totalCityXp => cities.fold(0, (s, c) => s + c.currentXp);
}