import 'dart:async';

import 'package:my_first_flutter_app/models/routine.dart';
import 'package:my_first_flutter_app/models/todo.dart';

class Uuid {
  const Uuid();
  String v4() => 'mock-id-${DateTime.now().microsecondsSinceEpoch}';
}

class DatabaseService {
  final Uuid _uuid = const Uuid();

  List<Todo> mockTodos = [
    Todo(id: 't1', title: 'Ôn tập Ngữ pháp Tiếng Anh', isCompleted: true),
    Todo(id: 't2', title: 'Làm bài Listening Test 1 (TOEIC)'),
    Todo(id: 't3', title: 'Đọc 10 trang sách Phát triển Bản thân'),
    Todo(id: 't4', title: 'Viết báo cáo hàng tuần'),
  ];
  List<RoutineTask> mockRoutines = [
    RoutineTask(
      id: 'r1',
      name: 'Uống 1 cốc nước ấm',
      time: '6:30 AM',
      isCompleted: true,
    ),
    RoutineTask(id: 'r2', name: 'Thiền 10 phút', time: '6:40 AM'),
    RoutineTask(id: 'r3', name: 'Tập thể dục nhẹ', time: '6:50 AM'),
    RoutineTask(id: 'r4', name: 'Đọc sách', time: '9:30 PM'),
  ];

  final StreamController<List<Todo>> _todoController =
      StreamController<List<Todo>>.broadcast();
  final StreamController<List<RoutineTask>> _routineController =
      StreamController<List<RoutineTask>>.broadcast();

  DatabaseService() {
    _todoController.add(mockTodos);
    _routineController.add(mockRoutines);
  }

  Stream<List<Todo>> getTodos(String userId) {
    return _todoController.stream;
  }

  Stream<List<RoutineTask>> getRoutines(String userId) {
    return _routineController.stream;
  }

  void addTodo(String userId, String title) {
    final newTodo = Todo(id: _uuid.v4(), title: title);
    mockTodos.add(newTodo);

    _todoController.add([...mockTodos]);
  }

  void addRoutine(String userId, String name, String time) {
    final newRoutine = RoutineTask(id: _uuid.v4(), name: name, time: time);
    mockRoutines.add(newRoutine);
    _routineController.add([...mockRoutines]);
  }

  void updateTodoCompletion(String todoId, bool isCompleted) {
    int index = mockTodos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      mockTodos[index].isCompleted = isCompleted;
      _todoController.add([...mockTodos]);
    }
  }

  void updateRoutineCompletion(String routineId, bool isCompleted) {
    int index = mockRoutines.indexWhere((r) => r.id == routineId);
    if (index != -1) {
      mockRoutines[index].isCompleted = isCompleted;
      _routineController.add([...mockRoutines]);
    }
  }
}
