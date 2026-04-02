class Habit {
  String id;
  String title;
  int difficulty; //1-3
  bool completed;
  DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    required this.difficulty,
    this.completed = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'difficulty': difficulty,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map map){
    return Habit(
      id: map['id'],
      title: map['title'],
      difficulty: map['difficulty'],
      completed: map['completed'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}