import 'dart:async';

class PomodoroService {
  Timer? _timer;
  int _remainingSeconds = 0;
  final StreamController<int> _timeController =
      StreamController<int>.broadcast();
  final StreamController<bool> _isRunningController =
      StreamController<bool>.broadcast();

  Stream<int> get timeStream => _timeController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _timer?.isActive ?? false;

  void start(int minutes) {
    if (_timer?.isActive ?? false) {
      stop();
    }
    _remainingSeconds = minutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _timeController.add(_remainingSeconds);
      } else {
        stop();
      }
    });
    _isRunningController.add(true);
  }

  void pause() {
    _timer?.cancel();
    _isRunningController.add(false);
  }

  void resume() {
    if (_remainingSeconds > 0 && !(_timer?.isActive ?? false)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _timeController.add(_remainingSeconds);
        } else {
          stop();
        }
      });
      _isRunningController.add(true);
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = 0;
    _timeController.add(0);
    _isRunningController.add(false);
  }

  void reset() {
    stop();
    _remainingSeconds = 0;
    _timeController.add(0);
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void dispose() {
    stop();
    _timeController.close();
    _isRunningController.close();
  }
}
