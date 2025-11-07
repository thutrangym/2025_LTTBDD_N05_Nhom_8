import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/routine_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/custom_button.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _selectedMinutes = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pomodoro'.tr())),
      body: Consumer<PomodoroProvider>(
        builder: (context, pomodoroProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CustomCard(
                  child: Column(
                    children: [
                      Text(
                        'set_timer'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTimeButton(15),
                          const SizedBox(width: 16),
                          _buildTimeButton(25),
                          const SizedBox(width: 16),
                          _buildTimeButton(45),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        pomodoroProvider.formattedTime,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pomodoroProvider.isRunning)
                            CustomButton(
                              text: 'pause'.tr(),
                              onPressed: () => pomodoroProvider.pause(),
                              width: 120,
                            )
                          else
                            CustomButton(
                              text: pomodoroProvider.remainingSeconds > 0
                                  ? 'resume'.tr()
                                  : 'start'.tr(),
                              onPressed: () =>
                                  pomodoroProvider.start(_selectedMinutes),
                              width: 120,
                            ),
                          const SizedBox(width: 16),
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
                const _TodoSelectionWidget(),
                const SizedBox(height: 16),
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

class _TodoSelectionWidget extends StatelessWidget {
  const _TodoSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final pomodoroProvider = context.read<PomodoroProvider>();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_todo'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (todoProvider.getTodayTodos().isEmpty)
            Text(
              'no_todos'.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            )
          else
            ...todoProvider.getTodayTodos().map((todo) {
              final isSelected = pomodoroProvider.selectedTodoId == todo.id;
              return ListTile(
                title: Text(todo.title),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  pomodoroProvider.setSelectedTodo(todo.id);
                },
              );
            }),
        ],
      ),
    );
  }
}

class _RoutineSelectionWidget extends StatelessWidget {
  const _RoutineSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final pomodoroProvider = context.read<PomodoroProvider>();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_routine'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (routineProvider.routines.isEmpty)
            Text(
              'no_routines'.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            )
          else
            ...routineProvider.routines.map((routine) {
              final isSelected =
                  pomodoroProvider.selectedRoutineId == routine.id;
              return ListTile(
                title: Text(routine.title),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  pomodoroProvider.setSelectedRoutine(routine.id);
                },
              );
            }),
        ],
      ),
    );
  }
}
