import 'package:flutter/material.dart';

enum WaifuMood { idle, happy, excited }

class WaifuCharacter extends StatelessWidget {
  final WaifuMood mood;

  const WaifuCharacter({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    String image;

    switch (mood) {
      case WaifuMood.happy:
        image = "assets/waifu_smile.png";
        break;
      case WaifuMood.excited:
        image = "assets/waifu_excited.png";
        break;
      default:
        image = "assets/waifu_idle.png";
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Image.asset(
        image,
        key: ValueKey(image),
        height: 120,
      ),
    );
  }
}