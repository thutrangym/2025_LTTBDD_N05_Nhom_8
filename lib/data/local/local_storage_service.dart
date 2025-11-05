import '../../models/todo_model.dart';
import '../../models/goal_model.dart';
import '../../models/routine_model.dart';
import 'hive_manager.dart';

class LocalStorageService {
  // Todo operations
  Future<void> saveTodo(TodoModel todo) async {
    await HiveManager.todosBox.put(todo.id, todo);
  }

  Future<void> deleteTodo(String id) async {
    await HiveManager.todosBox.delete(id);
  }

  Future<TodoModel?> getTodo(String id) async {
    return HiveManager.todosBox.get(id);
  }

  List<TodoModel> getAllTodos() {
    return HiveManager.todosBox.values.toList();
  }

  List<TodoModel> getTodosByDate(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return HiveManager.todosBox.values.where((todo) {
      final todoDate = todo.scheduledTime.toIso8601String().split('T')[0];
      return todoDate == dateStr;
    }).toList();
  }

  // Goal operations
  Future<void> saveGoal(GoalModel goal) async {
    await HiveManager.goalsBox.put(goal.id, goal);
  }

  Future<void> deleteGoal(String id) async {
    await HiveManager.goalsBox.delete(id);
  }

  Future<GoalModel?> getGoal(String id) async {
    return HiveManager.goalsBox.get(id);
  }

  List<GoalModel> getAllGoals() {
    return HiveManager.goalsBox.values.toList();
  }

  // Routine operations
  Future<void> saveRoutine(RoutineModel routine) async {
    await HiveManager.routinesBox.put(routine.id, routine);
  }

  Future<void> deleteRoutine(String id) async {
    await HiveManager.routinesBox.delete(id);
  }

  Future<RoutineModel?> getRoutine(String id) async {
    return HiveManager.routinesBox.get(id);
  }

  List<RoutineModel> getAllRoutines() {
    return HiveManager.routinesBox.values.toList();
  }

  List<RoutineModel> getRoutinesByType(String type) {
    return HiveManager.routinesBox.values
        .where((routine) => routine.type == type)
        .toList();
  }

  // Mood operations
  Future<void> saveMood(MoodModel mood) async {
    await HiveManager.moodsBox.put(mood.id, mood);
  }

  Future<MoodModel?> getMoodByDate(String date) async {
    try {
      return HiveManager.moodsBox.values.firstWhere(
        (mood) => mood.date == date,
      );
    } catch (e) {
      return null;
    }
  }

  List<MoodModel> getAllMoods() {
    return HiveManager.moodsBox.values.toList();
  }

  // Settings operations
  Future<void> saveSetting(String key, dynamic value) async {
    await HiveManager.settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return HiveManager.settingsBox.get(key, defaultValue: defaultValue);
  }
}
