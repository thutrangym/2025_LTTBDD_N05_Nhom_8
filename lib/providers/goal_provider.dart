import 'package:flutter/material.dart' hide DateUtils;
import '../models/goal_model.dart';
import '../data/repositories/goal_repository.dart';

class GoalProvider extends ChangeNotifier {
  final GoalRepository _repository;
  final String? userId;

  List<GoalModel> _goals = [];
  bool _isLoading = false;

  GoalProvider({required GoalRepository repository, this.userId})
    : _repository = repository {
    loadGoals();
  }

  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (userId != null) {
        _repository.getGoalsStream().listen((goals) {
          _goals = goals;
          _isLoading = false;
          notifyListeners();
        });
      } else {
        _goals = _repository.getAllGoals();
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('[GoalProvider] loadGoals() error: $e');
    }
  }

  Future<void> addGoal(GoalModel goal) async {
    try {
      await _repository.saveGoal(goal);
      await loadGoals();
    } catch (e) {
      throw Exception('Failed to add goal: $e');
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    try {
      await _repository.saveGoal(goal);
      await loadGoals();
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _repository.deleteGoal(id);
      await loadGoals();
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }

  Future<void> addDailyTask(String goalId, DailyTaskModel task) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      final updatedTasks = [...goal.dailyTasks, task];
      final completedCount =
          updatedTasks.where((element) => element.isCompleted).length;

      final updatedGoal = goal.copyWith(
        dailyTasks: updatedTasks,
        totalDays: updatedTasks.length,
        progressDays: completedCount,
      );

      await updateGoal(updatedGoal);
    } catch (e) {
      throw Exception('Failed to add daily task: $e');
    }
  }

  Future<void> updateDailyTask(
    String goalId,
    String date,
    bool isCompleted,
  ) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      final updatedTasks = goal.dailyTasks.map((task) {
        if (task.date == date) {
          return task.copyWith(isCompleted: isCompleted);
        }
        return task;
      }).toList();

      final updatedGoal = goal.copyWith(
        dailyTasks: updatedTasks,
        totalDays: updatedTasks.length,
        progressDays: updatedTasks.where((t) => t.isCompleted).length,
      );

      await updateGoal(updatedGoal);
    } catch (e) {
      throw Exception('Failed to update daily task: $e');
    }
  }

  List<DailyTaskModel> getTodayTasks(String goalId) {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      return goal.dailyTasks.where((t) => t.date == today).toList();
    } catch (e) {
      debugPrint('[GoalProvider] getTodayTasks() error: $e');
      return [];
    }
  }
}
