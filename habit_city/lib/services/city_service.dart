import 'package:flutter/material.dart';
import 'package:habit_city/core/game_engine.dart';

// Minimal CityTier type used to define evolution paths.
class CityTier {
  final int level;
  final String emoji;
  final String name;
  const CityTier(this.level, this.emoji, this.name);
}

// Minimal CityDistrict implementation so the service can compile and run.
// Adjust XP/level math to match your game's design as needed.
class CityDistrict {
  final String id;
  final String name;
  final String desc;
  final Color color;
  final String tag;
  final IconData icon;
  final List<CityTier> evolutionPath;

  int _xp = 0;
  int _level = 1;

  CityDistrict({
    required this.id,
    required this.name,
    required this.desc,
    required this.color,
    required this.tag,
    required this.icon,
    this.evolutionPath = const [],
  });

  int get level => _level;

  void addXP(int amount) {
    _xp += amount;
    // Simple leveling: 100 XP per level (tweak as needed)
    _level = 1 + (_xp ~/ 100);
    // Cap level to highest defined tier if evolutionPath provided
    if (evolutionPath.isNotEmpty) {
      final maxTier = evolutionPath.last.level;
      if (_level > maxTier) _level = maxTier;
    }
  }
}

class CityProgressionService extends ChangeNotifier {
  final GameEngine _gameEngine;
  final List<CityDistrict> _districts = [];
  
  CityProgressionService(this._gameEngine) {
    _initDefaultDistricts();
  }

  List<CityDistrict> get districts => List.unmodifiable(_districts);

  void _initDefaultDistricts() {
    _districts.addAll([
      CityDistrict(
        id: 'gym',
        name: "Gym",
        desc: "Train your body. Build raw power.",
        color: const Color(0xFFFF003C),
        tag: "BODY",
        icon: Icons.fitness_center_rounded,
        evolutionPath: const [
          CityTier(1, "👟", "Jogger"),
          CityTier(5, "🏋️", "Home Gym"),
          CityTier(10, "🥋", "Dojo"),
          CityTier(20, "🏟️", "Colosseum"),
        ],
      ),
      CityDistrict(
        id: 'mind',
        name: "Mind",
        desc: "Meditate, reflect, stay sharp.",
        color: const Color(0xFFFF00FF),
        tag: "MENTAL",
        icon: Icons.self_improvement_rounded,
        evolutionPath: const [
          CityTier(1, "⛺", "Camp"),
          CityTier(3, "🪵", "Cabin"),
          CityTier(5, "🏡", "Village"),
          CityTier(10, "🏬", "Town Center"),
          CityTier(15, "🏢", "City District"),
          CityTier(20, "🏙️", "Metropolis"),
        ],
      ),
    ]);
  }

  // When a task is completed in a city, BOTH systems update
  void executeCityTask(String districtId) {
    final district = _districts.firstWhere((d) => d.id == districtId);
    
    // 1. Add to city's own progression
    district.addXP(25);
    
    // 2. ALSO award global XP (this is the KEY connection)
    _gameEngine.awardXP(25, source: districtId);
    
    notifyListeners();
  }

  double get averageDistrictLevel {
    if (_districts.isEmpty) return 0;
    final total = _districts.fold(0, (sum, d) => sum + d.level);
    return total / _districts.length;
  }

  void addCustomDistrict(CityDistrict district) {
    _districts.add(district);
    notifyListeners();
  }
}