class RewardService {
  static int calculateXP(int difficulty) {
    return difficulty * 10; // Simple formula: 10 XP per difficulty level
  }

  static int calculateEnergy(int difficulty){
    return difficulty * 5; // Simple formula: 5 Energy per difficulty level
  }

  static int getLevel(int totalXP) {
    return (totalXP ~/ 100) + 1; // Level up every 100 XP
  }

  static int getCurrentLevelXP(int totalXP) {
    return totalXP % 100; // XP towards next level
  } 

  static int getXPForNextLevel(int level) {
    return level * 100; // XP needed for next level
  }
}
