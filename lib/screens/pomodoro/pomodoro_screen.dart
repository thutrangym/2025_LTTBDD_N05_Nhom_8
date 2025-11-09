import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/core/widgets/custom_button.dart';
import 'package:my_first_flutter_app/core/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/pomodoro_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/routine_provider.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _selectedMinutes = 25;

  @override
  void initState() {
    super.initState();
    // Load routines when screen initializes
    Future.microtask(() {
      context.read<RoutineProvider>().loadRoutines();
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pomodoro'.tr())),
      body: Consumer<PomodoroProvider>(
        builder: (context, pomodoroProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Time Selection
                CustomCard(
                  child: Column(
                    children: [
                      Text(
                        'set_timer'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildTimeButton(15),
                          _buildTimeButton(25),
                          _buildTimeButton(45),
                          _buildTimeButton(60),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Pomodoro Clock
                      Text(
                        pomodoroProvider.formattedTime,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Control Buttons
                      Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          CustomButton(
                            text: pomodoroProvider.isRunning
                                ? 'pause'.tr()
                                : pomodoroProvider.remainingSeconds > 0
                                ? 'resume'.tr()
                                : 'start'.tr(),
                            onPressed: pomodoroProvider.isRunning
                                ? () => pomodoroProvider.pause()
                                : () =>
                                      pomodoroProvider.start(_selectedMinutes),
                            width: 120,
                          ),
                          CustomButton(
                            text: 'stop'.tr(),
                            onPressed: () => pomodoroProvider.stop(),
                            width: 120,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Todo selection
                const _TodoSelectionWidget(),
                const SizedBox(height: 16),

                // Routine selection
                const _RoutineSelectionWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeButton(int minutes) {
    final isSelected = _selectedMinutes == minutes;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMinutes = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$minutes min',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// -------------------- Todo selection --------------------
class _TodoSelectionWidget extends StatelessWidget {
  const _TodoSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final pomodoroProvider = context.read<PomodoroProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'select_todo'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todoProvider.getTodayTodos().isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No todos'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            else
              ...todoProvider.getTodayTodos().map((todo) {
                final isSelected = pomodoroProvider.selectedTodoId == todo.id;
                return Material(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (_) =>
                          pomodoroProvider.setSelectedTodo(todo.id),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(todo.title),
                    onTap: () {
                      pomodoroProvider.setSelectedTodo(todo.id);
                    },
                  ),
                );
              }),
          ],
        ),
      ],
    );
  }
}

// -------------------- Routine selection --------------------
class _RoutineSelectionWidget extends StatelessWidget {
  const _RoutineSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final pomodoroProvider = context.read<PomodoroProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'select_routine'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (routineProvider.routines.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'no_routines'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            else
              ...routineProvider.routines.map((routine) {
                final isSelected =
                    pomodoroProvider.selectedRoutineId == routine.id;
                return Material(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (_) =>
                          pomodoroProvider.setSelectedRoutine(routine.id),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(routine.title),
                    onTap: () {
                      pomodoroProvider.setSelectedRoutine(routine.id);
                    },
                  ),
                );
              }),
          ],
        ),
      ],
    );
  }
}
