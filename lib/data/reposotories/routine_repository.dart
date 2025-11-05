import '../../models/routine_model.dart';
import '../local/local_storage_service.dart';

class RoutineRepository {
  final LocalStorageService _localStorage;

  RoutineRepository({required LocalStorageService localStorage})
    : _localStorage = localStorage;

  Future<void> saveRoutine(RoutineModel routine) async {
    await _localStorage.saveRoutine(routine);
  }

  Future<void> deleteRoutine(String routineId) async {
    await _localStorage.deleteRoutine(routineId);
  }

  Future<RoutineModel?> getRoutine(String routineId) async {
    return await _localStorage.getRoutine(routineId);
  }

  List<RoutineModel> getAllRoutines() {
    return _localStorage.getAllRoutines();
  }

  List<RoutineModel> getRoutinesByType(String type) {
    return _localStorage.getRoutinesByType(type);
  }

  Stream<List<RoutineModel>> getRoutinesStream() {
    return Stream.value(_localStorage.getAllRoutines());
  }
}
