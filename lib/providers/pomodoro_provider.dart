import 'dart:async';
import 'package:flutter/material.dart';
import '../services/pomodoro_service.dart';
import 'stats_provider.dart';
import 'goal_provider.dart';

class PomodoroProvider extends ChangeNotifier {
  final PomodoroService _service;
  String? _selectedTodoId;
  String? _selectedRoutineId;
  String _selectedType = 'todo'; // 'todo' or 'routine'
  StatsProvider? _statsProvider;
  GoalProvider? _goalProvider;
  int _startedMinutes = 0;

  StreamSubscription? _timeSubscription;
  StreamSubscription? _runningSubscription;
  bool _handlingCompletion = false;

  PomodoroProvider({required PomodoroService service}) : _service = service {
    _initSubscriptions();
  }

  void _initSubscriptions() {
    // Cancel existing subscriptions if any
    _timeSubscription?.cancel();
    _runningSubscription?.cancel();

    // Set up new subscriptions
    _timeSubscription = _service.timeStream.listen((remaining) async {
      // Ensure completion handler runs only once per completion to avoid
      // recursive stop -> time event -> onComplete loops.
      // debug print
      // ignore: avoid_print
      print('[PomodoroProvider] time event: $remaining');
      if (remaining == 0) {
        if (_handlingCompletion) return;
        _handlingCompletion = true;
        try {
          await _onTimerComplete();
        } finally {
          _handlingCompletion = false;
        }
      }
      notifyListeners();
    });

    _runningSubscription = _service.isRunningStream.listen((_) {
      notifyListeners();
    });
  }

  void attachDependencies(StatsProvider stats, GoalProvider goals) {
    if (_statsProvider != stats || _goalProvider != goals) {
      _statsProvider = stats;
      _goalProvider = goals;
      notifyListeners();
    }
  }

  int get remainingSeconds => _service.remainingSeconds;
  bool get isRunning => _service.isRunning;
  String? get selectedTodoId => _selectedTodoId;
  String? get selectedRoutineId => _selectedRoutineId;
  String get selectedType => _selectedType;

  String get formattedTime => _service.formatTime(remainingSeconds);

  void start(int minutes) {
    _startedMinutes = minutes;
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
    // Nếu dừng thủ công, không ghi nhận session
    _startedMinutes = 0;
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
    _timeSubscription?.cancel();
    _runningSubscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  // Đổi thành Future<void> để đảm bảo thao tác I/O là bất đồng bộ
  Future<void> _onTimerComplete() async {
    // record pomodoro session
    if (_statsProvider != null && _startedMinutes > 0) {
      // debug
      // ignore: avoid_print
      print('[PomodoroProvider] timer complete, minutes=$_startedMinutes');
      await _statsProvider!.addPomodoroSession(DateTime.now(), _startedMinutes);
      // NOTE: Cần đảm bảo hàm addPomodoroSession là Future (async)
    }

    // reset started minutes
    _startedMinutes = 0;
    // automatically reset service
    _service.reset();

    // Yêu cầu thông báo cho người dùng
    // (Đây là nơi bạn gọi NotificationService để thông báo hết giờ)

    notifyListeners();
  }
}
