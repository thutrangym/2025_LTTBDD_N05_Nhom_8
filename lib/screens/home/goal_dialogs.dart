import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../providers/goal_provider.dart';

Future<GoalModel?> showAddGoalDialog(BuildContext context) async {
  final goalProvider = context.read<GoalProvider>();
  final parentContext = context;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime startDate = DateTime.now();

  final result = await showDialog<GoalModel>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text('add_goal'.tr()),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'goal_title'.tr()),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'field_required'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          InputDecoration(labelText: 'goal_description'.tr()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.indigo),
                      title: Text(
                        DateFormat.yMMMd(context.locale.toLanguageTag())
                            .format(startDate),
                      ),
                      trailing: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              startDate = DateTime(
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
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final newGoal = GoalModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    dailyTasks: <DailyTaskModel>[],
                    progressDays: 0,
                    totalDays: 0,
                    startDate: startDate,
                    endDate: startDate,
                    createdAt: DateTime.now(),
                  );

                  try {
                    await goalProvider.addGoal(newGoal);
                    Navigator.of(dialogContext).pop(newGoal);
                  } catch (e) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text('auth_unexpected_error'.tr())),
                    );
                  }
                },
                child: Text('save'.tr()),
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}

