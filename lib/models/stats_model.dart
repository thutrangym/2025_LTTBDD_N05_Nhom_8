class StatsModel {
  final DateTime date;
  final int studyTimeMinutes;
  final int completedTodos;
  final double goalProgress;

  StatsModel({
    required this.date,
    this.studyTimeMinutes = 0,
    this.completedTodos = 0,
    this.goalProgress = 0.0,
  });

  StatsModel copyWith({
    DateTime? date,
    int? studyTimeMinutes,
    int? completedTodos,
    double? goalProgress,
  }) {
    return StatsModel(
      date: date ?? this.date,
      studyTimeMinutes: studyTimeMinutes ?? this.studyTimeMinutes,
      completedTodos: completedTodos ?? this.completedTodos,
      goalProgress: goalProgress ?? this.goalProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'studyTimeMinutes': studyTimeMinutes,
      'completedTodos': completedTodos,
      'goalProgress': goalProgress,
    };
  }

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      date: DateTime.parse(json['date']),
      studyTimeMinutes: json['studyTimeMinutes'] ?? 0,
      completedTodos: json['completedTodos'] ?? 0,
      goalProgress: (json['goalProgress'] ?? 0.0).toDouble(),
    );
  }
}
