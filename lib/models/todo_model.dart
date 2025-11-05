import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime scheduledTime;

  @HiveField(4)
  int reminderMinutes;

  @HiveField(5)
  String category; // work, personal, study, gym, other

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledTime,
    this.reminderMinutes = 0,
    this.category = 'other',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledTime,
    int? reminderMinutes,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledTime': scheduledTime.toIso8601String(),
      'reminderMinutes': reminderMinutes,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      reminderMinutes: json['reminderMinutes'] ?? 0,
      category: json['category'] ?? 'other',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
