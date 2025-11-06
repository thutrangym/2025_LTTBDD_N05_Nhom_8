import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../data/repositories/routine_repository.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;
  List<RoutineModel> _routines = [];
  bool _isLoading = false;

  RoutineProvider({required RoutineRepository repository})
    : _repository = repository {
    loadRoutines();
  }

  List<RoutineModel> get routines => _routines;
  bool get isLoading => _isLoading;

  List<RoutineModel> getMorningRoutines() {
    return _routines.where((r) => r.type == 'morning').toList();
  }

  List<RoutineModel> getEveningRoutines() {
    return _routines.where((r) => r.type == 'evening').toList();
  }

  List<RoutineModel> getRoutinesForToday() {
    final today = app_date_utils.DateUtils.formatDate(DateTime.now());
    return _routines.where((r) => r.completedTasks.containsKey(today)).toList();
  }

  Future<void> loadRoutines() async {
    _isLoading = true;
    notifyListeners();

    try {
      _routines = _repository.getAllRoutines();
    } catch (e) {
      debugPrint('[RoutineProvider] loadRoutines() error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRoutine(RoutineModel routine) async {
    try {
      await _repository.saveRoutine(routine);
      await loadRoutines();
    } catch (e) {
      throw Exception('Failed to add routine: $e');
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      await _repository.saveRoutine(routine);
      await loadRoutines();
    } catch (e) {
      throw Exception('Failed to update routine: $e');
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await _repository.deleteRoutine(id);
      await loadRoutines();
    } catch (e) {
      throw Exception('Failed to delete routine: $e');
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
    } catch (e) {
      throw Exception('Failed to toggle routine task: $e');
    }
  }

  bool isRoutineCompletedToday(String routineId) {
    try {
      final today = app_date_utils.DateUtils.formatDate(DateTime.now());
      final routine = _routines.firstWhere((r) => r.id == routineId);
      return routine.completedTasks[today] ?? false;
    } catch (e) {
      return false;
    }
  }
}
