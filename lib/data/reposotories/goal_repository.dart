import '../../models/goal_model.dart';
import '../local/local_storage_service.dart';

class GoalRepository {
  final LocalStorageService _localStorage;

  GoalRepository({required LocalStorageService localStorage})
    : _localStorage = localStorage;

  Future<void> saveGoal(GoalModel goal) async {
    await _localStorage.saveGoal(goal);
  }

  Future<void> deleteGoal(String goalId) async {
    await _localStorage.deleteGoal(goalId);
  }

  Future<GoalModel?> getGoal(String goalId) async {
    return await _localStorage.getGoal(goalId);
  }

  List<GoalModel> getAllGoals() {
    return _localStorage.getAllGoals();
  }

  Stream<List<GoalModel>> getGoalsStream() {
    return Stream.value(_localStorage.getAllGoals());
  }
}
