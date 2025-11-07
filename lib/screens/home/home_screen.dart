import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:my_first_flutter_app/screens/settings/setting_screen.dart';
import '../../providers/todo_provider.dart';
import '../../providers/goal_provider.dart';

import '../../models/user_model.dart';
import '../../models/todo_model.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/custom_card.dart';

import 'todo_list_widget.dart';
import 'goal_list_widget.dart';
import 'goals_detail_page.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  final Future<void> Function()? onSignOut;

  const HomeScreen({super.key, required this.user, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(onSignOut: onSignOut),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh will be handled by providers automatically
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(context),
              const SizedBox(height: 16),
              SectionHeader(title: "today_todos".tr()),
              const TodoListWidget(),
              const SizedBox(height: 16),
              SectionHeader(
                title: "goals".tr(),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openGoalSection(context),
              ),
              const GoalListWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting,',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.displayName ?? 'User',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddTodoDialog());
  }

  void _openGoalSection(BuildContext context) {
    final goalProvider = context.read<GoalProvider>();
    if (goalProvider.isLoading) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalsDetailPage()),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  int _reminderMinutes = 0;
  String _category = 'other';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add_todo'.tr()),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'job_name'.tr()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'detailed_content'.tr()),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('date'.tr()),
                subtitle: Text(
                  DateFormat.yMMMMd(
                    context.locale.toLanguageTag(),
                  ).format(_selectedTime),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('time'.tr()),
                subtitle: Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedTime),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedTime = DateTime(
                        _selectedTime.year,
                        _selectedTime.month,
                        _selectedTime.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'reminder_minutes'.tr()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _reminderMinutes = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(labelText: 'category'.tr()),
                items: ['work', 'personal', 'study', 'gym', 'other']
                    .map(
                      (cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat.tr())),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final todoProvider = context.read<TodoProvider>();
              final todo = TodoModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                scheduledTime: _selectedTime,
                reminderMinutes: _reminderMinutes,
                category: _category,
                createdAt: DateTime.now(),
              );
              todoProvider.addTodo(todo);
              Navigator.pop(context);
            }
          },
          child: Text('save'.tr()),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
