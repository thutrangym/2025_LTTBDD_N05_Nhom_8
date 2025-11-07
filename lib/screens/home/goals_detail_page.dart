import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../providers/goal_provider.dart';
import 'goal_list_widget.dart';
import 'goal_detail_screen.dart';
import 'goal_dialogs.dart';

class GoalsDetailPage extends StatelessWidget {
  const GoalsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('goal_detail'.tr())),
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, _) {
          if (goalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final goals = goalProvider.goals;

          if (goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'no_goals'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 96),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return GoalCardWidget(goal: goal);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGoal = await showAddGoalDialog(context);
          if (newGoal != null && context.mounted) {
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
}

