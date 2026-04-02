class RewardService {
  static int calculateXP(int difficulty) {
    return difficulty * 10; // Simple formula: 10 XP per difficulty level
  }

  static int calculateEnergy(int difficulty){
    return difficulty * 5; // Simple formula: 5 Energy per difficulty level
  }
}
