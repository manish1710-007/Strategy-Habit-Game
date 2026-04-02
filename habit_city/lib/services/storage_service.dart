import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String habitBox = "habits";

  static Future init() async {
    await Hive.initFlutter();
    await Hive.openBox(habitBox);
  }

  static Box getHabitBox() {
    return Hive.box(habitBox);
  }  
}