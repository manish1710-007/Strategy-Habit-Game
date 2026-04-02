import 'package:flutter/material.dart';

class CityScreen extends StatelessWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your City")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          _BuildingTile(name: "Gym 🏋️"),
          _BuildingTile(name: "Library 📚"),
          _BuildingTile(name: "Mind 🧠"),
          _BuildingTile(name: "Health ❤️"),
        ],
      ),
    );
  }
}

class _BuildingTile extends StatelessWidget {
  final String name;

  const _BuildingTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}