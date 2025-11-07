import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/stats_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/goal_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/utils/chart_utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedPeriod = 'daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('stats'.tr())),
      body: Consumer3<StatsProvider, TodoProvider, GoalProvider>(
        builder: (context, statsProvider, todoProvider, goalProvider, _) {
          // Update stats provider with current data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            statsProvider.setTodos(todoProvider.todos);
            statsProvider.setGoals(goalProvider.goals);
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSelector(),
                const SizedBox(height: 16),
                _buildStudyTimeChart(statsProvider),
                const SizedBox(height: 16),
                _buildGoalProgressChart(statsProvider),
                const SizedBox(height: 16),
                _buildCompletedTodosChart(statsProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'daily', label: Text('Daily')),
        ButtonSegment(value: 'monthly', label: Text('Monthly')),
      ],
      selected: {_selectedPeriod},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() {
          _selectedPeriod = newSelection.first;
        });
      },
    );
  }

  Widget _buildStudyTimeChart(StatsProvider statsProvider) {
    final stats = _selectedPeriod == 'daily'
        ? statsProvider.getLast7DaysStats()
        : statsProvider.getLast30DaysStats();

    final spots = stats.map((stat) {
      return FlSpot(
        stats.indexOf(stat).toDouble(),
        stat.studyTimeMinutes.toDouble(),
      );
    }).toList();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'study_time'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              ChartUtils.createLineChart(
                spots: spots,
                title: 'study_time'.tr(),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgressChart(StatsProvider statsProvider) {
    final stats = _selectedPeriod == 'daily'
        ? statsProvider.getLast7DaysStats()
        : statsProvider.getLast30DaysStats();

    final spots = stats.map((stat) {
      return FlSpot(stats.indexOf(stat).toDouble(), stat.goalProgress * 100);
    }).toList();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'goal_progress'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              ChartUtils.createLineChart(
                spots: spots,
                title: 'goal_progress'.tr(),
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTodosChart(StatsProvider statsProvider) {
    final stats = _selectedPeriod == 'daily'
        ? statsProvider.getLast7DaysStats()
        : statsProvider.getLast30DaysStats();

    final barGroups = stats.map((stat) {
      return BarChartGroupData(
        x: stats.indexOf(stat),
        barRods: [
          BarChartRodData(
            toY: stat.completedTodos.toDouble(),
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'completed_todos'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              ChartUtils.createBarChart(
                barGroups: barGroups,
                title: 'completed_todos'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
