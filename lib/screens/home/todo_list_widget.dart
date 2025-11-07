import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/todo_provider.dart';
import '../../models/todo_model.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/utils/date_utils.dart' as custom_date_utils;

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        if (todoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final todayTodos = todoProvider.getTodayTodos();

        if (todayTodos.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'no_todos'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: todayTodos.map((todo) {
            return TodoItemWidget(todo: todo);
          }).toList(),
        );
      },
    );
  }
}

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;

  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: todo.isCompleted,
            onChanged: (value) {
              todoProvider.toggleTodoComplete(todo.id);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (todo.description != null && todo.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      todo.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      custom_date_utils.DateUtils.formatTime(
                        todo.scheduledTime,
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    _buildCategoryChip(todo.category),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              todoProvider.deleteTodo(todo.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    Color? color;
    switch (category) {
      case 'work':
        color = Colors.blue;
        break;
      case 'personal':
        color = Colors.green;
        break;
      case 'study':
        color = Colors.purple;
        break;
      case 'gym':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.tr(),
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
