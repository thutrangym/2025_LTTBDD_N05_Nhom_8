import 'package:flutter/material.dart';
import '../models/stats_model.dart';
import '../models/todo_model.dart';
import '../models/goal_model.dart';
import '../core/utils/date_utils.dart' as app_date;

class StatsProvider extends ChangeNotifier {
  List<TodoModel> _todos = [];
  List<GoalModel> _goals = [];
  final Map<String, int> _pomodoroSessions = {}; // date -> minutes

  void setTodos(List<TodoModel> todos) {
    _todos = todos;
    notifyListeners();
  }

  void setGoals(List<GoalModel> goals) {
    _goals = goals;
    notifyListeners();
  }

  void addPomodoroSession(DateTime date, int minutes) {
    final dateStr = app_date.DateUtils.formatDate(date);
    _pomodoroSessions[dateStr] = (_pomodoroSessions[dateStr] ?? 0) + minutes;
    notifyListeners();
  }

  // Get study time for a specific date
  int getStudyTimeForDate(DateTime date) {
    final dateStr = app_date.DateUtils.formatDate(date);
    return _pomodoroSessions[dateStr] ?? 0;
  }

  // Get study time for a month
  Map<String, int> getStudyTimeForMonth(DateTime month) {
    final days = app_date.DateUtils.getDaysInMonth(month);
    final studyTimeMap = <String, int>{};
    for (final day in days) {
      final dateStr = app_date.DateUtils.formatDate(day);
      studyTimeMap[dateStr] = _pomodoroSessions[dateStr] ?? 0;
    }
    return studyTimeMap;
  }

  // Get completed todos count for a date
  int getCompletedTodosForDate(DateTime date) {
    return _todos.where((todo) {
      return app_date.DateUtils.isSameDay(todo.scheduledTime, date) &&
          todo.isCompleted;
    }).length;
  }

  // Get completed todos count for a month
  Map<String, int> getCompletedTodosForMonth(DateTime month) {
    final days = app_date.DateUtils.getDaysInMonth(month);
    final todosMap = <String, int>{};
    for (final day in days) {
      todosMap[app_date.DateUtils.formatDate(day)] = getCompletedTodosForDate(
        day,
      );
    }
    return todosMap;
  }

  // Get goal progress
  double getGoalProgress(String goalId) {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      return goal.progress;
    } catch (e) {
      return 0.0;
    }
  }

  // Get average goal progress
  double getAverageGoalProgress() {
    if (_goals.isEmpty) return 0.0;
    final totalProgress = _goals.fold(0.0, (sum, goal) => sum + goal.progress);
    return totalProgress / _goals.length;
  }

  // Get stats for last 7 days
  List<StatsModel> getLast7DaysStats() {
    final stats = <StatsModel>[];
    final now = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      stats.add(
        StatsModel(
          date: date,
          studyTimeMinutes: getStudyTimeForDate(date),
          completedTodos: getCompletedTodosForDate(date),
          goalProgress: getAverageGoalProgress(),
        ),
      );
    }
    return stats;
  }

  // Get stats for last 30 days
  List<StatsModel> getLast30DaysStats() {
    final stats = <StatsModel>[];
    final now = DateTime.now();
    for (var i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      stats.add(
        StatsModel(
          date: date,
          studyTimeMinutes: getStudyTimeForDate(date),
          completedTodos: getCompletedTodosForDate(date),
          goalProgress: getAverageGoalProgress(),
        ),
      );
    }
    return stats;
  }
}
