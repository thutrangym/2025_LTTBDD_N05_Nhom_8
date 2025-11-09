import 'package:flutter/material.dart' hide DateUtils;
import '../models/todo_model.dart';
import 'goal_provider.dart';
import '../data/repositories/todo_repository.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

class TodoProvider extends ChangeNotifier {
  final TodoRepository _repository;

  List<TodoModel> _todos = [];
  bool _isLoading = false;
  GoalProvider? _goalProvider;

  TodoProvider({required TodoRepository repository})
    : _repository = repository {
    loadTodos();
  }

  void attachGoalProvider(GoalProvider goals) {
    _goalProvider = goals;
  }

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;

  List<TodoModel> getTodayTodos() {
    final today = DateTime.now();
    return _todos.where((todo) {
      return app_date_utils.DateUtils.isSameDay(todo.scheduledTime, today);
    }).toList();
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = _repository.getAllTodos();
    } catch (e) {
      debugPrint('[TodoProvider] loadTodos() error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      await _repository.saveTodo(todo);
      await loadTodos();
    } catch (e) {
      debugPrint('[TodoProvider] addTodo() error: $e');
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _repository.saveTodo(todo);
      await loadTodos();
    } catch (e) {
      debugPrint('[TodoProvider] updateTodo() error: $e');
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _repository.deleteTodo(id);
      await loadTodos();
    } catch (e) {
      debugPrint('[TodoProvider] deleteTodo() error: $e');
      throw Exception('Failed to delete todo: $e');
    }
  }

  Future<void> toggleTodoComplete(String id) async {
    try {
      final todo = _todos.firstWhere((t) => t.id == id);
      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      await updateTodo(updatedTodo);
      // If this todo is linked to a goal, update the goal's daily task
      try {
        if (updatedTodo.goalId != null && _goalProvider != null) {
          final dateStr = updatedTodo.scheduledTime.toIso8601String().substring(
            0,
            10,
          );
          await _goalProvider!.updateDailyTask(
            updatedTodo.goalId!,
            dateStr,
            updatedTodo.isCompleted,
          );
        }
      } catch (e) {
        debugPrint('[TodoProvider] failed to update linked goal: $e');
      }
    } catch (e) {
      debugPrint('[TodoProvider] toggleTodoComplete() error: $e');
      throw Exception('Failed to toggle todo: $e');
    }
  }

  List<TodoModel> getTodosByDate(DateTime date) {
    return _todos.where((todo) {
      return app_date_utils.DateUtils.isSameDay(todo.scheduledTime, date);
    }).toList();
  }
}
