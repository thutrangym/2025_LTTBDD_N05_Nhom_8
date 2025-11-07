enum AppLanguage { vi, en }

Map<String, Map<AppLanguage, String>> translations = {
  // Navigation
  'home': {AppLanguage.vi: 'Trang Chủ', AppLanguage.en: 'Home'},
  'routine': {AppLanguage.vi: 'Thói Quen', AppLanguage.en: 'Routine'},
  'calendar': {AppLanguage.vi: 'Lịch', AppLanguage.en: 'Calendar'},
  'pomodoro': {AppLanguage.vi: 'Pomodoro', AppLanguage.en: 'Pomodoro'},
  'stats': {AppLanguage.vi: 'Thống Kê', AppLanguage.en: 'Stats'},
  'settings': {AppLanguage.vi: 'Cài Đặt', AppLanguage.en: 'Settings'},

  // Floating Action Button (NEW)
  'add_todo': {AppLanguage.vi: 'Thêm To-do', AppLanguage.en: 'Add To-do'},
  'add_routine': {
    AppLanguage.vi: 'Thêm Thói quen',
    AppLanguage.en: 'Add Routine',
  },
  'add_event': {AppLanguage.vi: 'Thêm Sự kiện', AppLanguage.en: 'Add Event'},

  // Login Screen
  'welcome': {
    AppLanguage.vi: 'Chào mừng đến với Self-Manager',
    AppLanguage.en: 'Welcome to Self-Manager',
  },
  'signin_google': {
    AppLanguage.vi: 'Đăng nhập bằng Google',
    AppLanguage.en: 'Sign in with Google',
  },
  'signing_in': {
    AppLanguage.vi: 'Đang đăng nhập...',
    AppLanguage.en: 'Signing in...',
  },
  'sign_out': {AppLanguage.vi: 'Đăng Xuất', AppLanguage.en: 'Sign Out'},

  // Home Screen
  'greeting': {AppLanguage.vi: 'Xin chào', AppLanguage.en: 'Hello'},
  'today_todo': {
    AppLanguage.vi: 'Việc Cần Làm Hôm Nay',
    AppLanguage.en: 'Today\'s To-Do',
  },
  'daily_goals': {
    AppLanguage.vi: 'Mục Tiêu (Goals) Đang Tiến Hành',
    AppLanguage.en: 'Ongoing Goals',
  },
  'daily_plan': {AppLanguage.vi: 'Kế Hoạch Ngày', AppLanguage.en: 'Daily Plan'},
  'check_in_mood': {
    AppLanguage.vi: 'Tâm Trạng Hôm Nay',
    AppLanguage.en: 'Today\'s Mood Check-in',
  },
  'view_all': {AppLanguage.vi: 'Xem tất cả', AppLanguage.en: 'View All'},

  // Routine Screen
  'morning_routine': {
    AppLanguage.vi: 'Thói Quen Buổi Sáng',
    AppLanguage.en: 'Morning Routine',
  },
  'evening_routine': {
    AppLanguage.vi: 'Thói Quen Buổi Tối',
    AppLanguage.en: 'Evening Routine',
  },

  // Pomodoro Screen
  'select_task': {
    AppLanguage.vi: 'Chọn việc để tập trung',
    AppLanguage.en: 'Select Task to Focus',
  },
  'start_focus': {
    AppLanguage.vi: 'Bắt Đầu Tập Trung',
    AppLanguage.en: 'Start Focus',
  },
  'pause': {AppLanguage.vi: 'Tạm Dừng', AppLanguage.en: 'Pause'},
  'resume': {AppLanguage.vi: 'Tiếp Tục', AppLanguage.en: 'Resume'},
  'finish': {AppLanguage.vi: 'Hoàn Thành', AppLanguage.en: 'Finish'},
  'set_duration': {
    AppLanguage.vi: 'Đặt thời gian (phút)',
    AppLanguage.en: 'Set duration (minutes)',
  },
  'task_completed': {
    AppLanguage.vi: 'Nhiệm vụ đã hoàn thành!',
    AppLanguage.en: 'Task completed!',
  },

  // Stats Screen
  'study_time': {
    AppLanguage.vi: 'Thời Gian Học/Làm Việc',
    AppLanguage.en: 'Focus Time',
  },
  'goal_progress': {
    AppLanguage.vi: 'Tiến Trình Mục Tiêu',
    AppLanguage.en: 'Goal Progress',
  },
  'completed_todos': {
    AppLanguage.vi: 'Số Việc Đã Hoàn Thành',
    AppLanguage.en: 'Completed Todos',
  },
  'total_tasks': {
    AppLanguage.vi: 'Tổng Số Nhiệm Vụ',
    AppLanguage.en: 'Total Tasks',
  },
  'daily_view': {AppLanguage.vi: 'Xem Theo Ngày', AppLanguage.en: 'Daily View'},
  'monthly_view': {
    AppLanguage.vi: 'Xem Theo Tháng',
    AppLanguage.en: 'Monthly View',
  },
  'mood_tracking': {
    AppLanguage.vi: 'Theo Dõi Tâm Trạng',
    AppLanguage.en: 'Mood Tracking',
  },

  // Settings Screen
  'general': {AppLanguage.vi: 'Chung', AppLanguage.en: 'General'},
  'theme': {AppLanguage.vi: 'Chủ Đề (Theme)', AppLanguage.en: 'Theme'},
  'light': {AppLanguage.vi: 'Sáng', AppLanguage.en: 'Light'},
  'dark': {AppLanguage.vi: 'Tối', AppLanguage.en: 'Dark'},
  'language': {AppLanguage.vi: 'Ngôn Ngữ', AppLanguage.en: 'Language'},
  'vietnamese': {AppLanguage.vi: 'Tiếng Việt', AppLanguage.en: 'Vietnamese'},
  'english': {AppLanguage.vi: 'Tiếng Anh', AppLanguage.en: 'English'},

  // Goal Detail
  'overall_progress': {
    AppLanguage.vi: 'Tiến độ Tổng thể',
    AppLanguage.en: 'Overall Progress',
  },
  'today_tasks': {
    AppLanguage.vi: 'Công việc Hôm nay',
    AppLanguage.en: 'Today\'s Work',
  },
  'tomorrow_tasks': {
    AppLanguage.vi: 'Công việc Ngày Mai',
    AppLanguage.en: 'Tomorrow\'s Work',
  },
  'work_needed': {
    AppLanguage.vi: 'Việc Cần Làm',
    AppLanguage.en: 'Work Needed',
  },
  'status': {AppLanguage.vi: 'Trạng Thái', AppLanguage.en: 'Status'},
};

String T(String key, AppLanguage lang) {
  return translations[key]?[lang] ?? key;
}
