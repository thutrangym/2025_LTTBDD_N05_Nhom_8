class MoodEntry {
  final String mood;
  final String icon;
  MoodEntry(this.mood, this.icon);
}

enum RoutineType { morning, evening }

class RoutineTask {
  final String id;
  final String name;
  final String time;
  bool isCompleted;
  RoutineTask({
    required this.id,
    required this.name,
    required this.time,
    this.isCompleted = false,
  });

  RoutineTask copyWith({
    String? id,
    String? name,
    String? time,
    bool? isCompleted,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'time': time, 'isCompleted': isCompleted};
  }
}
