import 'package:hive/hive.dart';
part 'routine_model.g.dart';

@HiveType(typeId: 3)
class RoutineModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type; // 'morning' or 'evening'

  @HiveField(3)
  List<String> tasks;

  @HiveField(4)
  Map<String, bool> completedTasks; // date -> isCompleted

  @HiveField(5)
  DateTime createdAt;

  RoutineModel({
    required this.id,
    required this.title,
    required this.type,
    required this.tasks,
    Map<String, bool>? completedTasks,
    required this.createdAt,
  }) : completedTasks = completedTasks ?? {};

  RoutineModel copyWith({
    String? id,
    String? title,
    String? type,
    List<String>? tasks,
    Map<String, bool>? completedTasks,
    DateTime? createdAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'tasks': tasks,
      'completedTasks': completedTasks,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      tasks: List<String>.from(json['tasks']),
      completedTasks: Map<String, bool>.from(json['completedTasks'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

@HiveType(typeId: 4)
class MoodModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String mood; // 'happy', 'neutral', 'sad'

  @HiveField(3)
  String? note;

  @HiveField(4)
  DateTime createdAt;

  MoodModel({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  MoodModel copyWith({
    String? id,
    String? date,
    String? mood,
    String? note,
    DateTime? createdAt,
  }) {
    return MoodModel(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'mood': mood,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'],
      date: json['date'],
      mood: json['mood'],
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
