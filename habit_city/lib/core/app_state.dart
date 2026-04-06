import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int xp = 0;
  int energy = 100;

  // level
  int get level => (xp ~/ 100) + 1;
  int get currentXP => xp % 100;

  // ADD XP
  void addXP(int value) {
    xp += value;
    notifyListeners();
  }

  // ADD ENERGY
  void addEnergy(int value) {
    energy += value;
    notifyListeners();
  }

  // RESET
  void reset() {
    xp = 0;
    energy = 100;
    notifyListeners();
  }
}