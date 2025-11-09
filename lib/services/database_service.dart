import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:my_first_flutter_app/data/local/hive_manager.dart';
import 'package:my_first_flutter_app/models/todo.dart';
import 'package:my_first_flutter_app/models/routine.dart';
import 'package:my_first_flutter_app/models/routine_model.dart';
import 'package:my_first_flutter_app/models/todo_model.dart';

/// Tạo ID duy nhất đơn giản
class Uuid {
  const Uuid();
  String v4() => 'id-${DateTime.now().microsecondsSinceEpoch}';
}

/// Dịch vụ quản lý dữ liệu Todo và Routine sử dụng Hive + Stream
class DatabaseService {
  final Uuid _uuid = const Uuid();

  late final StreamController<List<Todo>> _todoController;
  late final StreamController<List<RoutineTask>> _routineController;

  DatabaseService() {
    _todoController = StreamController<List<Todo>>.broadcast(
      onListen: _loadTodos,
    );
    _routineController = StreamController<List<RoutineTask>>.broadcast(
      onListen: _loadRoutines,
    );
  }

  // =====================================================
  // ====================== TODOS ========================
  // =====================================================

  Future<void> _loadTodos() async {
    try {
      final todos = HiveManager.todosBox.values
          .map(
            (todo) => Todo(
              id: todo.id,
              title: todo.title,
              isCompleted: todo.isCompleted,
            ),
          )
          .toList();
      _todoController.add(todos);
      print('Loaded ${todos.length} todos');
    } catch (e) {
      print('Error loading todos: $e');
      _todoController.add([]);
    }
  }

  Stream<List<Todo>> getTodos() => _todoController.stream;

  Future<void> addTodo(String title) async {
    try {
      final todo = TodoModel(
        id: _uuid.v4(),
        title: title,
        isCompleted: false,
        scheduledTime: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await HiveManager.todosBox.put(todo.id, todo);

      final todos = HiveManager.todosBox.values
          .map(
            (todo) => Todo(
              id: todo.id,
              title: todo.title,
              isCompleted: todo.isCompleted,
            ),
          )
          .toList();
      _todoController.add(todos);
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodoCompletion(String todoId, bool isCompleted) async {
    try {
      final todo = HiveManager.todosBox.get(todoId);
      if (todo != null) {
        todo.isCompleted = isCompleted;
        await HiveManager.todosBox.put(todoId, todo);

        final todos = HiveManager.todosBox.values
            .map(
              (todo) => Todo(
                id: todo.id,
                title: todo.title,
                isCompleted: todo.isCompleted,
              ),
            )
            .toList();
        _todoController.add(todos);
      }
    } catch (e) {
      print('Error updating todo completion: $e');
    }
  }

  // =====================================================
  // ==================== ROUTINES =======================
  // =====================================================

  Future<void> _loadRoutines() async {
    try {
      print('Loading routines from Hive...');
      // Diagnostic info
      try {
        print('routines box open: ${HiveManager.routinesBox.isOpen}');
        print('routines box length: ${HiveManager.routinesBox.length}');
        print('routines box keys: ${HiveManager.routinesBox.keys.toList()}');
      } catch (diagErr) {
        print('Error reading routines box diagnostics: $diagErr');
      }

      final routines = HiveManager.routinesBox.values
          .map(
            (routine) => RoutineTask(
              id: routine.id,
              name: routine.title,
              time: routine.tasks.isNotEmpty ? routine.tasks[0] : '12:00 PM',
              isCompleted:
                  routine.completedTasks[DateTime.now().toIso8601String()] ??
                  false,
            ),
          )
          .toList();
      print('Loaded ${routines.length} routines from Hive');
      // Print raw values for easier debugging when empty
      if (routines.isEmpty) {
        try {
          final raw = HiveManager.routinesBox.values.toList();
          print('Raw routinesBox values: $raw');
        } catch (e) {
          print('Error reading raw routines box values: $e');
        }
      }
      _routineController.add(routines);
    } catch (e) {
      print('Error loading routines: $e');
      _routineController.add([]);
    }
  }

  Stream<List<RoutineTask>> getRoutines() => _routineController.stream;

  Future<void> addRoutine(String name, String time, RoutineType type) async {
    print('Adding routine: name=$name, time=$time, type=$type');
    try {
      final routine = RoutineModel(
        id: _uuid.v4(),
        title: name,
        type: type == RoutineType.morning ? 'morning' : 'evening',
        tasks: [time],
        createdAt: DateTime.now(),
      );

      await HiveManager.routinesBox.put(routine.id, routine);
      print('Saved routine to Hive: ${routine.id}');
      try {
        print(
          'After save - routines box length: ${HiveManager.routinesBox.length}',
        );
        print(
          'After save - routines box keys: ${HiveManager.routinesBox.keys.toList()}',
        );
      } catch (e) {
        print('Error reading routines box after save: $e');
      }

      // Reload all routines to trigger UI update
      await _loadRoutines();
    } catch (e, stackTrace) {
      print('Error adding routine: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> updateRoutineCompletion(
    String routineId,
    bool isCompleted,
  ) async {
    try {
      final routine = HiveManager.routinesBox.get(routineId);
      if (routine != null) {
        final today = DateTime.now().toIso8601String();
        routine.completedTasks[today] = isCompleted;
        await HiveManager.routinesBox.put(routineId, routine);
        await _loadRoutines();
      }
    } catch (e) {
      print('Error updating routine completion: $e');
    }
  }

  Stream<List<RoutineTask>> getRoutinesByType(RoutineType type) {
    print('Getting routines by type: $type');
    return _routineController.stream.map((routines) {
      print('Filtering ${routines.length} routines for type $type');
      List<RoutineTask> filtered;
      if (type == RoutineType.morning) {
        filtered = routines
            .where((r) => r.time.compareTo('12:00 PM') < 0)
            .toList();
      } else {
        filtered = routines
            .where((r) => r.time.compareTo('12:00 PM') >= 0)
            .toList();
      }
      print('Found ${filtered.length} ${type.toString()} routines');
      return filtered;
    });
  }

  Future<void> deleteRoutine(String routineId) async {
    try {
      await HiveManager.routinesBox.delete(routineId);
      await _loadRoutines();
    } catch (e) {
      print('Error deleting routine: $e');
    }
  }

  // =====================================================
  // ==================== CLEANUP ========================
  // =====================================================

  void dispose() {
    _todoController.close();
    _routineController.close();
  }
}
