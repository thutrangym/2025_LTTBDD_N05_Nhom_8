import 'dart:async';

class PomodoroService {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;
  final _timeController = StreamController<int>.broadcast();
  final _isRunningController = StreamController<bool>.broadcast();

  Stream<int> get timeStream => _timeController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _timer?.isActive ?? false;

  void start(int minutes) {
    // Stop any existing timer but don't emit a 0 time event here because
    // start() will immediately set a new remaining time and emit that. If
    // we emit 0 here providers may interpret it as a completion.
    stop(emitEvent: false);
    _remainingSeconds = minutes * 60;
    _isPaused = false;
    _startTimer();
    // debug
    // ignore: avoid_print
    print('[PomodoroService] start: $_remainingSeconds seconds');
    _timeController.add(_remainingSeconds);
    _isRunningController.add(true);
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _isPaused = true;
    // ignore: avoid_print
    print('[PomodoroService] pause');
    _isRunningController.add(false);
  }

  void resume() {
    if (_remainingSeconds > 0 && _isPaused) {
      _isPaused = false;
      _startTimer();
      _isRunningController.add(true);
    }
  }

  /// Stop the timer. If [emitEvent] is true (default) a 0 time event will be
  /// emitted on the time stream so listeners know the timer reached/stopped at
  /// zero. When stopping internally (for example, inside `start`) set
  /// [emitEvent] to false to avoid spurious completion events.
  void stop({bool emitEvent = true}) {
    _timer?.cancel();
    _timer = null;
    _isPaused = false;
    _remainingSeconds = 0;
    if (emitEvent) {
      _timeController.add(0);
    }
    // ignore: avoid_print
    print('[PomodoroService] stop emitEvent=$emitEvent');
    _isRunningController.add(false);
  }

  void reset() {
    stop();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _timeController.add(_remainingSeconds);
          if (_remainingSeconds == 0) {
            stop();
          }
        } else {
          stop();
        }
      } catch (e, st) {
        // Catch unexpected errors in the timer callback to avoid uncaught
        // exceptions that may crash the isolate.
        // ignore: avoid_print
        print('[PomodoroService] timer callback error: $e\n$st');
        stop();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void dispose() {
    stop();
    try {
      if (!_timeController.isClosed) _timeController.close();
      if (!_isRunningController.isClosed) _isRunningController.close();
    } catch (e) {
      // Ignore if already closed
    }
  }
}
