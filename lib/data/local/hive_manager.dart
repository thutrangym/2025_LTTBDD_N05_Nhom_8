import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/todo_model.dart';
import '../../models/goal_model.dart';
import '../../models/routine_model.dart';

class HiveManager {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    // Register adapters
    try {
      Hive.registerAdapter(TodoModelAdapter());
      Hive.registerAdapter(GoalModelAdapter());
      Hive.registerAdapter(DailyTaskModelAdapter());
      Hive.registerAdapter(RoutineModelAdapter());
      Hive.registerAdapter(MoodModelAdapter());
    } catch (e) {
      // Adapters not generated yet - run: flutter pub run build_runner build
      debugPrint(
        'Hive adapters not found. Run: flutter pub run build_runner build',
      );
      debugPrint('Error: $e');
    }

    // Open boxes
    try {
      await Hive.openBox<TodoModel>('todos');
      await Hive.openBox<GoalModel>('goals');
      await Hive.openBox<RoutineModel>('routines');
      await Hive.openBox<MoodModel>('moods');
      await Hive.openBox('settings');
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
      debugPrint('Make sure Hive adapters are generated first');
    }

    _initialized = true;
  }

  static Box<TodoModel> get todosBox => Hive.box<TodoModel>('todos');
  static Box<GoalModel> get goalsBox => Hive.box<GoalModel>('goals');
  static Box<RoutineModel> get routinesBox =>
      Hive.box<RoutineModel>('routines');
  static Box<MoodModel> get moodsBox => Hive.box<MoodModel>('moods');
  static Box get settingsBox => Hive.box('settings');
}
