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
      debugPrint('LoadGoals error: $e');
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

  Future<void> updateDailyTask(
    String goalId,
    String date,
    bool isCompleted,
  ) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      final tasks = goal.dailyTasks.map((task) {
        if (task.date == date) {
          return task.copyWith(isCompleted: isCompleted);
        }
        return task;
      }).toList();

      final completedCount = tasks.where((t) => t.isCompleted).length;
      final updatedGoal = goal.copyWith(
        dailyTasks: tasks,
        progressDays: completedCount,
      );

      await updateGoal(updatedGoal);
    } catch (e) {
      throw Exception('Failed to update daily task: $e');
    }
  }

  List<DailyTaskModel> getTodayTasks(String goalId) {
    final goal = _goals.firstWhere((g) => g.id == goalId);
    return goal.dailyTasks.toList();
  }
}
