import 'package:flutter/material.dart';
import '../services/pomodoro_service.dart';

class PomodoroProvider extends ChangeNotifier {
  final PomodoroService _service;
  String? _selectedTodoId;
  String? _selectedRoutineId;
  String _selectedType = 'todo'; // 'todo' or 'routine'

  PomodoroProvider({required PomodoroService service}) : _service = service {
    _service.timeStream.listen((_) => notifyListeners());
    _service.isRunningStream.listen((_) => notifyListeners());
  }

  int get remainingSeconds => _service.remainingSeconds;
  bool get isRunning => _service.isRunning;
  String? get selectedTodoId => _selectedTodoId;
  String? get selectedRoutineId => _selectedRoutineId;
  String get selectedType => _selectedType;

  String get formattedTime => _service.formatTime(remainingSeconds);

  void start(int minutes) {
    _service.start(minutes);
    notifyListeners();
  }

  void pause() {
    _service.pause();
    notifyListeners();
  }

  void resume() {
    _service.resume();
    notifyListeners();
  }

  void stop() {
    _service.stop();
    notifyListeners();
  }

  void reset() {
    _service.reset();
    notifyListeners();
  }

  void setSelectedTodo(String? todoId) {
    _selectedTodoId = todoId;
    _selectedRoutineId = null;
    _selectedType = 'todo';
    notifyListeners();
  }

  void setSelectedRoutine(String? routineId) {
    _selectedRoutineId = routineId;
    _selectedTodoId = null;
    _selectedType = 'routine';
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
