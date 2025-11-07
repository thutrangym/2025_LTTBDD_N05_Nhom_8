import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../providers/goal_provider.dart';
import '../../providers/todo_provider.dart';
import '../../models/goal_model.dart';
import '../../models/todo_model.dart';
import '../../core/widgets/custom_card.dart';
import 'goal_dialogs.dart';

class GoalDetailScreen extends StatefulWidget {
  final GoalModel goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late GoalModel _goal;
  final _dailyPlanFormKey = GlobalKey<FormState>();
  final TextEditingController _dailyTaskController = TextEditingController();
  DateTime _dailyPlanDate = DateTime.now();
  bool _isAddingDailyPlan = false;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  @override
  void dispose() {
    _dailyTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
            CustomCard(
              child: Form(
                key: _dailyPlanFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'daily_plan_create'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        DateFormat.yMMMMd(context.locale.toLanguageTag())
                            .format(_dailyPlanDate),
                      ),
                      trailing: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dailyPlanDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _dailyPlanDate = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                              );
                            });
                          }
                        },
                        child: Text('select_date'.tr()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dailyTaskController,
                      decoration:
                          InputDecoration(labelText: 'task_to_do'.tr()),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'field_required'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed:
                            _isAddingDailyPlan ? null : _submitDailyPlan,
                        icon: _isAddingDailyPlan
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.add),
                        label: Text('add_plan'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_goal.dailyTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'no_daily_tasks'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ),
            ..._sortedTasks().map((task) {
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        _handleToggleDailyTask(task, value ?? false);
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMMd(
                              context.locale.toLanguageTag(),
                            ).format(DateTime.parse(task.date)),
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
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGoal = await showAddGoalDialog(context);
          if (!mounted) return;
          if (newGoal != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('goal_added'.tr())),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GoalDetailScreen(goal: newGoal),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
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

  List<DailyTaskModel> _sortedTasks() {
    final tasks = [..._goal.dailyTasks];
    tasks.sort((a, b) => a.date.compareTo(b.date));
    return tasks;
  }

  Future<void> _submitDailyPlan() async {
    if (!_dailyPlanFormKey.currentState!.validate()) {
      return;
    }

    final goalProvider = context.read<GoalProvider>();
    final todoProvider = context.read<TodoProvider>();

    final taskText = _dailyTaskController.text.trim();
    final dateStr = DateFormat('yyyy-MM-dd').format(_dailyPlanDate);

    if (_goal.dailyTasks.any((task) =>
        task.date == dateStr && task.work.toLowerCase() == taskText.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('daily_task_exists'.tr())),
      );
      return;
    }

    final newTask = DailyTaskModel(date: dateStr, work: taskText);
    final updatedTasks = [..._goal.dailyTasks, newTask];
    final completedCount = updatedTasks.where((t) => t.isCompleted).length;

    final updatedGoal = _goal.copyWith(
      dailyTasks: updatedTasks,
      totalDays: updatedTasks.length,
      progressDays: completedCount,
    );

    setState(() {
      _isAddingDailyPlan = true;
    });

    try {
      await goalProvider.updateGoal(updatedGoal);
      await _createTodoForDailyTask(todoProvider, newTask);

      setState(() {
        _goal = updatedGoal;
        _dailyTaskController.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('daily_plan_added'.tr())),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth_unexpected_error'.tr())),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isAddingDailyPlan = false;
      });
    }
  }

  Future<void> _createTodoForDailyTask(
    TodoProvider todoProvider,
    DailyTaskModel task,
  ) async {
    final scheduledDate = DateTime.parse('${task.date}T09:00:00');
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: task.work,
      description: 'From goal: ${_goal.title}',
      scheduledTime: scheduledDate,
      category: 'other',
      createdAt: DateTime.now(),
    );

    await todoProvider.addTodo(todo);
  }

  void _handleToggleDailyTask(DailyTaskModel task, bool isCompleted) {
    final goalProvider = context.read<GoalProvider>();

    goalProvider.updateDailyTask(_goal.id, task.date, isCompleted);

    final updatedTasks = _goal.dailyTasks.map((t) {
      if (t.date == task.date && t.work == task.work) {
        return t.copyWith(isCompleted: isCompleted);
      }
      return t;
    }).toList();

    final completedCount = updatedTasks.where((t) => t.isCompleted).length;

    setState(() {
      _goal = _goal.copyWith(
        dailyTasks: updatedTasks,
        totalDays: updatedTasks.length,
        progressDays: completedCount,
      );
    });
  }
}
