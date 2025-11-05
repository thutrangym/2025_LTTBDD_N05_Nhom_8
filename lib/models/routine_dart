// RoutineTask and MoodEntry Models are combined here for simplicity

class MoodEntry {
  final String mood;
  final String icon;
  MoodEntry(this.mood, this.icon);
}

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
}
