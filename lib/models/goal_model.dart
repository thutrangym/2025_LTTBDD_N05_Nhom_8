import 'package:hive/hive.dart';
part 'goal_model.g.dart';

@HiveType(typeId: 1)
class DailyTaskModel extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String work;

  @HiveField(2)
  bool isCompleted;

  DailyTaskModel({
    required this.date,
    required this.work,
    this.isCompleted = false,
  });

  DailyTaskModel copyWith({String? date, String? work, bool? isCompleted}) {
    return DailyTaskModel(
      date: date ?? this.date,
      work: work ?? this.work,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'work': work, 'isCompleted': isCompleted};
  }

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      date: json['date'],
      work: json['work'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

@HiveType(typeId: 2)
class GoalModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<DailyTaskModel> dailyTasks;

  @HiveField(4)
  int progressDays;

  @HiveField(5)
  int totalDays;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime endDate;

  @HiveField(8)
  DateTime createdAt;

  GoalModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.dailyTasks,
    this.progressDays = 0,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  double get progress => totalDays > 0 ? progressDays / totalDays : 0.0;

  GoalModel copyWith({
    String? id,
    String? title,
    String? description,
    List<DailyTaskModel>? dailyTasks,
    int? progressDays,
    int? totalDays,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      progressDays: progressDays ?? this.progressDays,
      totalDays: totalDays ?? this.totalDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dailyTasks': dailyTasks.map((task) => task.toJson()).toList(),
      'progressDays': progressDays,
      'totalDays': totalDays,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      dailyTasks: (json['dailyTasks'] as List)
          .map((task) => DailyTaskModel.fromJson(task))
          .toList(),
      progressDays: json['progressDays'] ?? 0,
      totalDays: json['totalDays'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
