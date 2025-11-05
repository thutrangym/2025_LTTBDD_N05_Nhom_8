import '../../models/todo_model.dart';
import '../local/local_storage_service.dart';

class TodoRepository {
  final LocalStorageService _localStorage;

  TodoRepository({required LocalStorageService localStorage})
    : _localStorage = localStorage;

  Future<void> saveTodo(TodoModel todo) async {
    await _localStorage.saveTodo(todo);
  }

  Future<void> deleteTodo(String todoId) async {
    await _localStorage.deleteTodo(todoId);
  }

  Future<TodoModel?> getTodo(String todoId) async {
    return await _localStorage.getTodo(todoId);
  }

  List<TodoModel> getAllTodos() {
    return _localStorage.getAllTodos();
  }

  List<TodoModel> getTodosByDate(DateTime date) {
    return _localStorage.getTodosByDate(date);
  }

  Stream<List<TodoModel>> getTodosStream() {
    return Stream.value(_localStorage.getAllTodos());
  }
}
