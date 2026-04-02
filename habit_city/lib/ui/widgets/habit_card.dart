import 'package:flutter/material.dart';
import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = habit.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: isDone
              ? const Color(0xFF00FFCC)
              : const Color(0xFF2A2A35),
        ),

        boxShadow: isDone
            ? [
                BoxShadow(
                  color: const Color(0xFF00FFCC).withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //  LEFT SIDE (Title + XP)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDone ? Colors.grey : Colors.white,
                  decoration:
                      isDone ? TextDecoration.lineThrough : null,
                ),
              ),

              const SizedBox(height: 6),

              //  XP + Difficulty
              Row(
                children: [
                  Text(
                    "+${habit.difficulty * 10} XP",
                    style: const TextStyle(
                      color: Color(0xFFFF00FF), // neon magenta
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _difficultyDots(habit.difficulty),
                ],
              ),
            ],
          ),

          //  RIGHT SIDE (Action Button)
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? const Color(0xFF00FFCC)
                    : Colors.transparent,
                border: Border.all(
                  color: const Color(0xFF00FFCC),
                ),
              ),

              child: Icon(
                isDone ? Icons.check : Icons.bolt,
                color: isDone ? Colors.black : const Color(0xFF00FFCC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Difficulty Indicator (dots)
  Widget _difficultyDots(int level) {
    return Row(
      children: List.generate(
        level,
        (index) => Container(
          margin: const EdgeInsets.only(right: 4),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}