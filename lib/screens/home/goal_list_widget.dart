import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../providers/goal_provider.dart';
import '../../models/goal_model.dart';
import '../../core/widgets/custom_card.dart';
import 'goal_detail_screen.dart';

class GoalListWidget extends StatelessWidget {
  const GoalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalProvider>(
      builder: (context, goalProvider, _) {
        if (goalProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final goals = goalProvider.goals;

        if (goals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'no_goals'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: goals.map((goal) {
            return GoalCardWidget(goal: goal);
          }).toList(),
        );
      },
    );
  }
}

class GoalCardWidget extends StatelessWidget {
  final GoalModel goal;

  const GoalCardWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalDetailScreen(goal: goal)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalDetailScreen(goal: goal),
                    ),
                  );
                },
              ),
            ],
          ),
          if (goal.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: goal.progress,
            backgroundColor: Colors.grey[300]!,
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(goal.progress * 100).toStringAsFixed(0)}% ${'progress'.tr()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${goal.progressDays}/${goal.totalDays} ${'days'.tr()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
