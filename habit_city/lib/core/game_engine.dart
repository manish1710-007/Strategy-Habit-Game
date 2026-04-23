import 'package:flutter/foundation.dart';


// SINGLE SOURCE OF TRUTH: Player Progress

class GameEngine extends ChangeNotifier {
  int _xp = 0;
  int _energy = 100;
  int _completedHabits = 0;
  DateTime? _lastCompletedDate;

  // Getters
  int get totalXP => _xp;
  int get energy => _energy;
  int get completedHabits => _completedHabits;

  int get level => (_xp ~/ 100) + 1;
  int get currentXP => _xp % 100;
  double get levelProgress => currentXP / 100;

  String get rankLabel {
    final lvl = level;
    if (lvl >= 20) return 'CYBER GOD';
    if (lvl >= 15) return 'NETRUNNER';
    if (lvl >= 10) return 'OPERATIVE';
    if (lvl >= 5) return 'RECRUIT';
    return 'SCRIPT KIDDIE';
  }


  // XP Awards
  static const int xpEasy = 10;
  static const int xpMedium = 15;
  static const int xpHard = 25;
  static const int xpCityTask = 25;

  // Award XP from ANY source (habit, mission, city task)
  void awardXP(int amount, {String source = 'general'}) {
    final oldLevel = level;
    _xp += amount;

    // Energy caps at 200
    _energy = (_energy + (amount ~/ 2)).clamp(0, 200).toInt();
    
    notifyListeners();

    // Return true if leveled up so UI can show dialog
    if (level > oldLevel) {
      // Level up happened - listeners can react
    }
  }

  // Complete a habit/mission
  void completeActivity(String id, int difficulty) {
    final gained = difficulty * 10;
    _xp += gained;
    _energy = (_energy + 5).clamp(0, 100).toInt();
    _completedHabits++;
    notifyListeners();
  }

  void spendEnergy(int amount) {
    _energy = (_energy - amount).clamp(0, 100).toInt();
    notifyListeners();
  }

  void reset() {
    _xp = 0;
    _energy = 100;
    _completedHabits = 0;
    notifyListeners();
  }

  void loadFromStorage(Map<String, dynamic> data) {
    _xp = data['totalXP'] ?? 0;
    _energy = data['energy'] ?? 100;
    _completedHabits = data['completedHabits'] ?? 0;
    if (data['lastCompleted'] != null) {
      _lastCompletedDate = DateTime.parse(data['lastCompleted']);
    }
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
    'totalXP': _xp,
    'energy': _energy,
    'completedHabits': _completedHabits,
    'lastCompleted': _lastCompletedDate?.toIso8601String(),
  };
}
