import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../data/repositories/routine_repository.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;
  final List<RoutineModel> _routines = [];
  bool _isLoading = false;

  RoutineProvider({required RoutineRepository repository})
    : _repository = repository;

  List<RoutineModel> get routines => _routines;
  bool get isLoading => _isLoading;

  List<RoutineModel> getMorningRoutines() =>
      _routines.where((r) => r.type == 'morning').toList();

  List<RoutineModel> getEveningRoutines() =>
      _routines.where((r) => r.type == 'evening').toList();

  List<RoutineModel> getRoutinesForToday() {
    final today = app_date_utils.DateUtils.formatDate(DateTime.now());
    return _routines.where((r) => r.completedTasks.containsKey(today)).toList();
  }

  Future<void> loadRoutines() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _repository.getAllRoutines();
      _routines
        ..clear()
        ..addAll(data);
    } catch (e) {
      debugPrint('Failed to load routines: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRoutine(RoutineModel routine) async {
    try {
      await _repository.saveRoutine(routine);
      _routines.add(routine);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to add routine: $e');
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      await _repository.saveRoutine(routine);
      final index = _routines.indexWhere((r) => r.id == routine.id);
      if (index != -1) {
        _routines[index] = routine;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to update routine: $e');
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await _repository.deleteRoutine(id);
      _routines.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to delete routine: $e');
    }
  }

  Future<void> toggleRoutineTask(String routineId, bool completed) async {
    try {
      final routine = _routines.firstWhere((r) => r.id == routineId);
      final today = app_date_utils.DateUtils.formatDate(DateTime.now());

      final updatedCompletedTasks = Map<String, bool>.from(
        routine.completedTasks,
      );
      updatedCompletedTasks[today] = completed;

      final updatedRoutine = routine.copyWith(
        completedTasks: updatedCompletedTasks,
      );

      await updateRoutine(updatedRoutine);
      notifyListeners(); // Important!
    } catch (e) {
      debugPrint('Failed to toggle routine task: $e');
    }
  }

  bool isRoutineCompletedToday(String routineId) {
    try {
      final today = app_date_utils.DateUtils.formatDate(DateTime.now());
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.completedTasks[today] ?? false;
    } catch (_) {
      return false;
    }
  }
}
