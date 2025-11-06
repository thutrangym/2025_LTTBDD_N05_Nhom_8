import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/goal_provider.dart';
import '../../providers/todo_provider.dart';
import '../../models/goal_model.dart';
import '../../models/todo_model.dart';
import '../../core/widgets/custom_card.dart';

class GoalDetailScreen extends StatefulWidget {
  final GoalModel goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late GoalModel _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.read<GoalProvider>();
    final todoProvider = context.read<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_goal.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditGoalDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'goal_description'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _goal.description.isEmpty
                        ? 'No description'
                        : _goal.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'progress'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _goal.progress,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_goal.progressDays}/${_goal.totalDays} ${'days'.tr()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'daily_plan'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._goal.dailyTasks.map((task) {
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        goalProvider.updateDailyTask(
                          _goal.id,
                          task.date,
                          value ?? false,
                        );
                        setState(() {
                          _goal = _goal.copyWith(
                            dailyTasks: _goal.dailyTasks.map((t) {
                              if (t.date == task.date) {
                                return t.copyWith(isCompleted: value ?? false);
                              }
                              return t;
                            }).toList(),
                            progressDays: _goal.dailyTasks
                                .where((t) => t.isCompleted)
                                .length,
                          );
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.date,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          Text(
                            task.work,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_task),
                      onPressed: () {
                        _addTaskToTodo(context, task, todoProvider);
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context) {
    final titleController = TextEditingController(text: _goal.title);
    final descriptionController = TextEditingController(
      text: _goal.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('edit'.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'goal_title'.tr()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'goal_description'.tr()),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              final goalProvider = context.read<GoalProvider>();
              final updatedGoal = _goal.copyWith(
                title: titleController.text,
                description: descriptionController.text,
              );
              goalProvider.updateGoal(updatedGoal);
              setState(() {
                _goal = updatedGoal;
              });
              Navigator.pop(context);
            },
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }

  void _addTaskToTodo(
    BuildContext context,
    DailyTaskModel task,
    TodoProvider todoProvider,
  ) {
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: task.work,
      description: 'From goal: ${_goal.title}',
      scheduledTime: DateTime.now(),
      category: 'study',
      createdAt: DateTime.now(),
    );

    todoProvider.addTodo(todo);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Task added to todo list')));
  }
}
