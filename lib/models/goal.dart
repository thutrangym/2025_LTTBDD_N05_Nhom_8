// Goal and DailyTask Models are combined here for simplicity

class DailyTask {
  final String date;
  final String work;
  bool isCompleted;
  DailyTask(this.date, this.work, {this.isCompleted = false});
}

class Goal {
  final String title;
  final String dailyPlan;
  int progressDays;
  final int totalDays;
  Goal(this.title, this.dailyPlan, this.progressDays, this.totalDays);
  double get progress => progressDays / totalDays;
}
