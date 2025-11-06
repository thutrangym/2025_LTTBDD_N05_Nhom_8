import '../core/utils/notification_utils.dart';
import '../models/todo_model.dart';

class NotificationService {
  static Future<void> initialize() async {
    await NotificationUtils.initialize();
  }

  static Future<void> scheduleTodoReminder(TodoModel todo) async {
    if (todo.reminderMinutes <= 0) return;

    final reminderTime = todo.scheduledTime.subtract(
      Duration(minutes: todo.reminderMinutes),
    );

    if (reminderTime.isBefore(DateTime.now())) return;

    await NotificationUtils.scheduleNotification(
      id: todo.id.hashCode,
      title: 'Todo Reminder',
      body: todo.title,
      scheduledDate: reminderTime,
    );
  }

  static Future<void> cancelTodoReminder(String todoId) async {
    await NotificationUtils.cancelNotification(todoId.hashCode);
  }

  static Future<void> scheduleRoutineReminder({
    required String id,
    required String title,
    required DateTime scheduledTime,
    int reminderMinutes = 5,
  }) async {
    final reminderTime = scheduledTime.subtract(
      Duration(minutes: reminderMinutes),
    );

    if (reminderTime.isBefore(DateTime.now())) return;

    await NotificationUtils.scheduleNotification(
      id: id.hashCode,
      title: 'Routine Reminder',
      body: title,
      scheduledDate: reminderTime,
    );
  }
}
