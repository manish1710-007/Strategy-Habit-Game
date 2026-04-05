import 'package:flutter/material.dart';
import '../../models/habit.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final Function(Offset) onTapWithPosition;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTapWithPosition,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  bool _animate = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _handleTap(TapDownDetails details) async {
    if (widget.habit.completed) return;

    setState(() => _animate = true);

    await _controller.forward();
    await _controller.reverse();

    widget.onTapWithPosition(details.globalPosition);

    setState(() => _animate = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.habit.completed;

    return ScaleTransition(
      scale: _scale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          gradient: LinearGradient(
            colors: isDone
                ? [
                    const Color(0xFFFF77E9),
                    const Color(0xFF7AFBFF),
                  ]
                : [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF141422),
                  ],
          ),

          boxShadow: _animate || isDone
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF77E9).withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TEXT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.habit.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration:
                        isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "+${widget.habit.difficulty * 10} XP",
                  style: const TextStyle(
                    color: Color(0xFF7AFBFF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // BUTTON
            GestureDetector(
              onTapDown: (details) {
                final position = details.globalPosition;
                widget.onTapWithPosition(position);
              },

              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? Colors.white
                      : const Color(0xFFFF77E9),
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.flash_on,
                  color: isDone ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}