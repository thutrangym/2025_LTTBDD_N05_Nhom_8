import 'package:flutter/material.dart' hide DateUtils;
import '../models/todo_model.dart';
import '../data/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository _repository;
  List<TodoModel> _todos = [];
  bool _isLoading = false;

  TodoProvider({required TodoRepository repository})
    : _repository = repository {
    _loadTodos();
  }

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;

  void _loadTodos() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = _repository.getAllTodos();
    } catch (e) {
      debugPrint('Error loading todos: $e');
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
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _repository.saveTodo(todo);

      await loadTodos();
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _repository.deleteTodo(id);
      await loadTodos();
    } catch (e) {
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
    } catch (e) {
      throw Exception('Failed to toggle todo: $e');
    }
  }
}
