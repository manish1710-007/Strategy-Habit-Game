import 'package:flutter/material.dart';

class CityDistrict {
  final String id;
  final String name;
  final String desc;
  final Color color;
  final String tag;
  final IconData icon;
  final List<CityTier> evolutionPath;
  final bool isAuto;
  
  // This city's contribution to global XP is tracked separately
  int _contributedXP;

  CityDistrict({
    required this.id,
    required this.name,
    required this.desc,
    required this.color,
    required this.tag,
    required this.icon,
    required this.evolutionPath,
    this.isAuto = false,
    int contributedXP = 0,
  }) : _contributedXP = contributedXP;

  int get contributedXP => _contributedXP;
  
  // City level is derived from its OWN XP pool
  int get level => (_contributedXP ~/ 100) + 1;
  double get progress => (_contributedXP % 100) / 100;
  
  CityTier get currentTier {
    CityTier active = evolutionPath.first;
    for (var tier in evolutionPath) {
      if (level >= tier.levelThreshold) active = tier;
      else break;
    }
    return active;
  }

  void addXP(int amount) => _contributedXP += amount;
  
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'color': color.value,
    'tag': tag,
    'contributedXP': _contributedXP,
    'isAuto': isAuto,
  };
}

class CityTier {
  final int levelThreshold;
  final String name;
  final IconData? icon;
  final Color? color;

  CityTier({
    required this.levelThreshold,
    this.name = '',
    this.icon,
    this.color,
  });
}

